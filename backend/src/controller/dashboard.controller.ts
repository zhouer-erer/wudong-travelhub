/**
 * 数据看板控制器
 * 提供平台运营数据统计接口，包含多维度统计数据
 * 统计维度：时间维度（今日/本周/本月）、模块维度、商家维度、财务维度
 *
 * 注意：所有时间比较使用 MySQL 函数（CURDATE/DATE_SUB）而非 JS Date，
 * 避免 Node.js 与 MySQL 之间的时区偏差
 */
import { Controller, Get, Inject } from '@midwayjs/decorator';
import { Context } from '@midwayjs/koa';
import { InjectEntityModel } from '@midwayjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../entity/user.entity';
import { Order } from '../entity/order.entity';
import { Merchant } from '../entity/merchant.entity';
import { MerchantApplication } from '../entity/merchant-application.entity';
import { FinancialRecord } from '../entity/financial-record.entity';
import { UserService } from '../service/user.service';
import { MerchantService } from '../service/merchant.service';
import { OrderService } from '../service/order.service';
import { FinancialRecordService } from '../service/financial-record.service';

@Controller('/api/dashboard')
export class DashboardController {
  @Inject()
  ctx: Context;

  @Inject()
  userService: UserService;

  @Inject()
  merchantService: MerchantService;

  @Inject()
  orderService: OrderService;

  @Inject()
  financialRecordService: FinancialRecordService;

  @InjectEntityModel(User)
  userRepo: Repository<User>;

  @InjectEntityModel(Order)
  orderRepo: Repository<Order>;

  @InjectEntityModel(Merchant)
  merchantRepo: Repository<Merchant>;

  @InjectEntityModel(MerchantApplication)
  applicationRepo: Repository<MerchantApplication>;

  @InjectEntityModel(FinancialRecord)
  recordRepo: Repository<FinancialRecord>;

  /**
   * 获取平台总览数据
   * GET /api/dashboard/overview
   */
  @Get('/overview')
  async overview() {
    try {
      const [userStats, orderStats, merchantStats, financialStats, orderTrend, moduleDistribution, moduleGMV, topMerchants, overdueApplications, conversionRates] = await Promise.all([
        this.getUserStats(),
        this.getOrderStats(),
        this.getMerchantStats(),
        this.getFinancialStats(),
        this.getOrderTrend(),
        this.getModuleDistribution(),
        this.getModuleGMV(),
        this.getTopMerchants(),
        this.getOverdueApplications(),
        this.getConversionRates(),
      ]);

      return {
        code: 200,
        message: 'success',
        data: {
          users: userStats,
          orders: orderStats,
          merchants: merchantStats,
          financial: financialStats,
          orderTrend,
          moduleDistribution,
          moduleGMV,
          topMerchants,
          overdueApplications,
          conversionRates,
        },
      };
    } catch (error) {
      return { code: 500, message: error.message, data: null };
    }
  }

  /**
   * 获取用户统计（今日/本周/本月 DAU、新增用户、总数）
   * 使用 MySQL CURDATE()/DATE_SUB() 避免时区问题
   */
  private async getUserStats() {
    const [total, todayActive, weekActive, monthActive, todayNew, weekNew, monthNew] = await Promise.all([
      this.userRepo.createQueryBuilder('u').where('u.is_deleted = 0').getCount(),
      this.userRepo.createQueryBuilder('u').where('u.is_deleted = 0').andWhere('DATE(u.last_login_at) = CURDATE()').getCount(),
      this.userRepo.createQueryBuilder('u').where('u.is_deleted = 0').andWhere('u.last_login_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)').getCount(),
      this.userRepo.createQueryBuilder('u').where('u.is_deleted = 0').andWhere('u.last_login_at >= DATE_FORMAT(CURDATE(), "%Y-%m-01")').getCount(),
      this.userRepo.createQueryBuilder('u').where('u.is_deleted = 0').andWhere('DATE(u.created_at) = CURDATE()').getCount(),
      this.userRepo.createQueryBuilder('u').where('u.is_deleted = 0').andWhere('u.created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)').getCount(),
      this.userRepo.createQueryBuilder('u').where('u.is_deleted = 0').andWhere('u.created_at >= DATE_FORMAT(CURDATE(), "%Y-%m-01")').getCount(),
    ]);

    return { total, todayActive, weekActive, monthActive, todayNew, weekNew, monthNew };
  }

  /**
   * 获取订单统计（今日/本周/本月 订单数和 GMV、总数）
   */
  private async getOrderStats() {
    const baseQb = () => this.orderRepo.createQueryBuilder('o').where('o.is_deleted = 0');

    const [total, todayCount, weekCount, monthCount, todayGMV, weekGMV, monthGMV] = await Promise.all([
      baseQb().getCount(),
      baseQb().andWhere('DATE(o.created_at) = CURDATE()').getCount(),
      baseQb().andWhere('o.created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)').getCount(),
      baseQb().andWhere('o.created_at >= DATE_FORMAT(CURDATE(), "%Y-%m-01")').getCount(),
      baseQb().andWhere('DATE(o.created_at) = CURDATE()').select('COALESCE(SUM(o.total_amount),0)', 'sum').getRawOne(),
      baseQb().andWhere('o.created_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)').select('COALESCE(SUM(o.total_amount),0)', 'sum').getRawOne(),
      baseQb().andWhere('o.created_at >= DATE_FORMAT(CURDATE(), "%Y-%m-01")').select('COALESCE(SUM(o.total_amount),0)', 'sum').getRawOne(),
    ]);

    return {
      total,
      todayCount, weekCount, monthCount,
      todayGMV: Number(todayGMV?.sum || 0),
      weekGMV: Number(weekGMV?.sum || 0),
      monthGMV: Number(monthGMV?.sum || 0),
    };
  }

  /**
   * 获取商家统计（总数、活跃商家数）
   */
  private async getMerchantStats() {
    const total = await this.merchantRepo.createQueryBuilder('m').where('m.is_deleted = 0').getCount();
    const activeResult = await this.orderRepo.createQueryBuilder('o')
      .select('COUNT(DISTINCT o.merchant_id)', 'count')
      .where('o.is_deleted = 0')
      .andWhere('o.status IN (:...statuses)', { statuses: ['paid', 'shipped', 'completed'] })
      .andWhere('o.merchant_id IS NOT NULL')
      .getRawOne();
    return { total, active: Number(activeResult?.count || 0) };
  }

  /**
   * 获取财务统计（总流水、平台收入、商家收入、待结算）
   */
  private async getFinancialStats() {
    const result = await this.recordRepo.createQueryBuilder('r')
      .select([
        'COALESCE(SUM(r.order_amount),0) as totalRevenue',
        'COALESCE(SUM(r.commission_amount),0) as platformIncome',
        'COALESCE(SUM(r.merchant_income),0) as merchantIncome',
      ])
      .where('r.is_deleted = 0')
      .getRawOne();

    const pendingResult = await this.recordRepo.createQueryBuilder('r')
      .select('COALESCE(SUM(r.merchant_income),0)', 'pending')
      .where('r.is_deleted = 0')
      .andWhere('r.settlement_status = :s', { s: 'pending' })
      .getRawOne();

    return {
      totalRevenue: Number(result?.totalRevenue || 0),
      platformIncome: Number(result?.platformIncome || 0),
      merchantIncome: Number(result?.merchantIncome || 0),
      pendingSettlement: Number(pendingResult?.pending || 0),
    };
  }

  /**
   * 获取近7天订单趋势（按日期分组）
   * 使用 MySQL DATE() 函数比较，避免时区偏差
   */
  private async getOrderTrend() {
    const days: string[] = [];
    const counts: number[] = [];
    const now = new Date();

    for (let i = 6; i >= 0; i--) {
      const d = new Date(now);
      d.setDate(d.getDate() - i);
      const label = `${d.getMonth() + 1}/${d.getDate()}`;
      days.push(label);

      // 用 DATE() 函数提取日期部分比较
      const dateStr = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
      const count = await this.orderRepo.createQueryBuilder('o')
        .where('o.is_deleted = 0')
        .andWhere('DATE(o.created_at) = :date', { date: dateStr })
        .getCount();
      counts.push(count);
    }

    return { days, counts };
  }

  /**
   * 获取商家模块分布（按 module_type 分组统计）
   */
  private async getModuleDistribution() {
    const results = await this.merchantRepo.createQueryBuilder('m')
      .select('m.module_type', 'module')
      .addSelect('COUNT(*)', 'count')
      .where('m.is_deleted = 0')
      .groupBy('m.module_type')
      .getRawMany();

    return results.map(r => ({ module: r.module, count: Number(r.count) }));
  }

  /**
   * 获取各模块订单量和 GMV（按 order_type 分组统计）
   */
  private async getModuleGMV() {
    const results = await this.orderRepo.createQueryBuilder('o')
      .select('o.order_type', 'type')
      .addSelect('COUNT(*)', 'count')
      .addSelect('COALESCE(SUM(o.total_amount),0)', 'gmv')
      .where('o.is_deleted = 0')
      .groupBy('o.order_type')
      .getRawMany();

    return results.map(r => ({ type: r.type, count: Number(r.count), gmv: Number(r.gmv) }));
  }

  /**
   * 获取 TOP5 商家（按 GMV 排序）
   */
  private async getTopMerchants() {
    const results = await this.orderRepo.createQueryBuilder('o')
      .select('o.merchant_id', 'merchantId')
      .addSelect('COUNT(*)', 'orderCount')
      .addSelect('COALESCE(SUM(o.total_amount),0)', 'gmv')
      .where('o.is_deleted = 0')
      .andWhere('o.merchant_id IS NOT NULL')
      .groupBy('o.merchant_id')
      .orderBy('gmv', 'DESC')
      .limit(5)
      .getRawMany();

    const merchantIds = results.map(r => r.merchantId).filter(Boolean);
    let merchantMap: Record<number, string> = {};
    if (merchantIds.length > 0) {
      const merchants = await this.merchantRepo
        .createQueryBuilder('m')
        .select(['m.id', 'm.shop_name'])
        .whereInIds(merchantIds)
        .getMany();
      merchants.forEach(m => { merchantMap[m.id] = m.shop_name; });
    }

    return results.map(r => ({
      merchantId: r.merchantId,
      shopName: merchantMap[r.merchantId] || `商家${r.merchantId}`,
      orderCount: Number(r.orderCount),
      gmv: Number(r.gmv),
    }));
  }

  /**
   * 获取各模块转化率（已完成订单 / 总订单 * 100）
   */
  private async getConversionRates() {
    const results = await this.orderRepo.createQueryBuilder('o')
      .select('o.order_type', 'type')
      .addSelect('COUNT(*)', 'total')
      .addSelect(`SUM(CASE WHEN o.status = 'completed' THEN 1 ELSE 0 END)`, 'completed')
      .where('o.is_deleted = 0')
      .groupBy('o.order_type')
      .getRawMany();

    return results.map(r => ({
      type: r.type,
      total: Number(r.total),
      completed: Number(r.completed || 0),
      rate: r.total > 0 ? Number(((Number(r.completed || 0) / Number(r.total)) * 100).toFixed(1)) : 0,
    }));
  }

  /**
   * 获取超时未审核的申请数量（超过3天）
   */
  private async getOverdueApplications() {
    const list = await this.applicationRepo.createQueryBuilder('a')
      .where('a.is_deleted = 0')
      .andWhere('a.status = :s', { s: 'pending' })
      .andWhere('a.created_at < DATE_SUB(NOW(), INTERVAL 3 DAY)')
      .getMany();

    return {
      count: list.length,
      list: list.map(a => ({
        id: a.id,
        shopName: a.shop_name,
        daysOverdue: Math.floor((Date.now() - new Date(a.created_at).getTime()) / (24 * 60 * 60 * 1000)),
      })),
    };
  }
}
