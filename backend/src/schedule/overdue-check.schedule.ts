import { Provide, Inject } from '@midwayjs/decorator';
import { Job } from '@midwayjs/cron';
import { MerchantApplicationService } from '../service/merchant-application.service';

/**
 * 入驻申请超时检查定时任务
 * 每天早上9点自动检查超过3个工作日未处理的入驻申请
 * 为每条超时申请创建系统消息提醒管理员（同一天不重复创建）
 */
@Provide()
@Job('overdue-check', {
  cronTime: '0 0 9 * * *', // 每天早上9:00
  start: true,
})
export class OverdueCheckSchedule {
  @Inject()
  merchantApplicationService: MerchantApplicationService;

  async onTick() {
    console.log('[定时任务] 开始检查超时入驻申请...');
    try {
      const result = await this.merchantApplicationService.checkOverdueApplications();
      if (result.overdueCount > 0) {
        console.log(`[定时任务] 发现 ${result.overdueCount} 条超时申请，已创建系统消息提醒`);
      } else {
        console.log('[定时任务] 没有超时的入驻申请');
      }
    } catch (error) {
      console.error('[定时任务] 超时检查失败:', error);
    }
  }
}
