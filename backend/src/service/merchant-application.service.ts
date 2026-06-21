import { Provide, Inject } from '@midwayjs/decorator';
import { InjectEntityModel } from '@midwayjs/typeorm';
import { Repository } from 'typeorm';
import { MerchantApplication } from '../entity/merchant-application.entity';
import { SystemMessageService } from './system-message.service';

/**
 * 商家入驻申请服务
 * 处理商家入驻申请的提交、查询、审核等操作
 */
@Provide()
export class MerchantApplicationService {
  @InjectEntityModel(MerchantApplication)
  applicationRepo: Repository<MerchantApplication>;

  @Inject()
  systemMessageService: SystemMessageService;

  /**
   * 分页查询商家入驻申请列表
   * @param page 页码，默认第 1 页
   * @param pageSize 每页条数，默认 20
   * @param status 申请状态筛选
   * @param keyword 搜索关键词（匹配店铺名称或申请人姓名）
   * @returns 包含列表、总数、页码和每页条数的分页结果
   */
  async findAll(page = 1, pageSize = 20, status?: string, keyword?: string) {
    const qb = this.applicationRepo.createQueryBuilder('application')
      .where('application.is_deleted = 0');
    if (status) {
      qb.andWhere('application.status = :status', { status });
    }
    if (keyword) {
      qb.andWhere('(application.shop_name LIKE :kw OR application.applicant_name LIKE :kw)', { kw: `%${keyword}%` });
    }
    const [list, total] = await qb
      .orderBy('application.id', 'DESC')
      .skip((page - 1) * pageSize)
      .take(pageSize)
      .getManyAndCount();
    return { list, total, page, pageSize };
  }

  /**
   * 根据 ID 查找入驻申请
   * @param id 申请 ID
   * @returns 申请实体或 null
   */
  async findById(id: number) {
    return await this.applicationRepo.findOne({ where: { id, is_deleted: 0 } });
  }

  /**
   * 根据状态分页查询入驻申请
   * @param status 申请状态
   * @param page 页码，默认第 1 页
   * @param pageSize 每页条数，默认 20
   * @returns 包含列表、总数、页码和每页条数的分页结果
   */
  async findByStatus(status: string, page = 1, pageSize = 20) {
    const qb = this.applicationRepo.createQueryBuilder('application')
      .where('application.is_deleted = 0')
      .andWhere('application.status = :status', { status });
    const [list, total] = await qb
      .orderBy('application.id', 'DESC')
      .skip((page - 1) * pageSize)
      .take(pageSize)
      .getManyAndCount();
    return { list, total, page, pageSize };
  }

  /**
   * 创建入驻申请
   * @param data 申请数据（部分字段）
   * @returns 创建成功的申请实体
   */
  async create(data: Partial<MerchantApplication>) {
    const entity = this.applicationRepo.create(data);
    return await this.applicationRepo.save(entity);
  }

  /**
   * 更新入驻申请信息
   * @param id 申请 ID
   * @param data 需要更新的字段
   * @returns 更新后的申请实体
   */
  async update(id: number, data: Partial<MerchantApplication>) {
    await this.applicationRepo.update(id, data);
    return await this.findById(id);
  }

  /**
   * 软删除入驻申请
   * @param id 申请 ID
   * @returns 更新结果
   */
  async delete(id: number) {
    return await this.applicationRepo.update(id, { is_deleted: 1 });
  }

  /**
   * 审批通过入驻申请
   * @param id 申请 ID
   * @param reviewerId 审核人 ID
   * @returns 更新后的申请实体
   */
  async approve(id: number, reviewerId: number) {
    await this.applicationRepo.update(id, {
      status: 'approved',
      reviewer_id: reviewerId,
      review_time: new Date(),
    });
    return await this.findById(id);
  }

  /**
   * 审批拒绝入驻申请
   * @param id 申请 ID
   * @param reviewerId 审核人 ID
   * @param reason 拒绝原因
   * @returns 更新后的申请实体
   */
  async reject(id: number, reviewerId: number, reason: string) {
    await this.applicationRepo.update(id, {
      status: 'rejected',
      reviewer_id: reviewerId,
      review_time: new Date(),
      reject_reason: reason,
    });
    return await this.findById(id);
  }

  /**
   * 检查超时未处理的入驻申请
   * 查询状态为 pending 且创建时间超过3天的申请
   * 为每条超时申请创建系统消息提醒管理员
   * @returns 超时申请数量和详情
   */
  async checkOverdueApplications() {
    const threshold = new Date(Date.now() - 3 * 24 * 60 * 60 * 1000);
    const overdueList = await this.applicationRepo
      .createQueryBuilder('application')
      .where('application.is_deleted = 0')
      .andWhere('application.status = :status', { status: 'pending' })
      .andWhere('application.created_at < :threshold', { threshold })
      .getMany();

    // 查询今天已创建的超时提醒消息，避免重复
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    const existingMessages = await this.systemMessageService.messageRepo
      .createQueryBuilder('msg')
      .where('msg.title = :title', { title: '入驻申请超时提醒' })
      .andWhere('msg.created_at >= :today', { today })
      .andWhere('msg.is_deleted = 0')
      .getMany();
    const existingContents = new Set(existingMessages.map(m => m.content));

    // 为每条超时申请创建系统消息（去重）
    for (const app of overdueList) {
      const content = `商家入驻申请「${app.shop_name}」（申请人：${app.applicant_name}）已超过3个工作日未处理，请尽快审核。`;
      if (!existingContents.has(content)) {
        await this.systemMessageService.create({
          user_id: null as any,
          message_type: 'system',
          title: '入驻申请超时提醒',
          content,
          is_read: 0,
        });
      }
    }

    return {
      overdueCount: overdueList.length,
      overdueList: overdueList.map(a => ({
        id: a.id,
        shopName: a.shop_name,
        applicantName: a.applicant_name,
        createdAt: a.created_at,
        daysOverdue: Math.floor((Date.now() - new Date(a.created_at).getTime()) / (24 * 60 * 60 * 1000)),
      })),
    };
  }
}
