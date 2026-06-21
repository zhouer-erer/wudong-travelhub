import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'recommendation', comment: '推荐位表' })
export class Recommendation {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 100, comment: '推荐位名称' })
  name: string;

  @Column({ type: 'varchar', length: 30, default: '', comment: '关联内容类型：product/restaurant/homestay/route/travel_note（暂未开放，预留字段）' })
  content_type: string;

  @Column({ type: 'int', default: 0, comment: '关联内容ID（暂未开放，预留字段）' })
  content_id: number;

  @Column({ type: 'int', default: 0, comment: '排序' })
  sort_order: number;

  @Column({ type: 'tinyint', default: 1, comment: '状态：1-启用 0-禁用' })
  status: number;

  @CreateDateColumn()
  created_at: Date;

  @UpdateDateColumn()
  updated_at: Date;

  @Column({ type: 'tinyint', default: 0, comment: '软删除标记' })
  is_deleted: number;
}
