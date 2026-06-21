import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'merchant', comment: '商家账号表' })
export class Merchant {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'int', nullable: true, comment: '关联用户ID' })
  user_id: number;

  @Column({ type: 'varchar', length: 50, comment: '商家用户名' })
  username: string;

  @Column({ type: 'varchar', length: 255, comment: '密码' })
  password_hash: string;

  @Column({ type: 'varchar', length: 100, comment: '店铺名称' })
  shop_name: string;

  @Column({ type: 'varchar', length: 50, comment: '所属模块：clothing/food/stay/travel' })
  module_type: string;

  @Column({ type: 'varchar', length: 50, comment: '联系人姓名' })
  contact_name: string;

  @Column({ type: 'varchar', length: 20, comment: '联系电话' })
  contact_phone: string;

  @Column({ type: 'varchar', length: 20, nullable: true, comment: '绑定手机号（登录验证/接收通知）' })
  phone: string;

  @Column({ type: 'varchar', length: 500, nullable: true, comment: '店铺Logo' })
  logo: string;

  @Column({ type: 'text', nullable: true, comment: '店铺简介' })
  description: string;

  @Column({ type: 'varchar', length: 255, nullable: true, comment: '店铺地址' })
  address: string;

  @Column({ type: 'tinyint', default: 1, comment: '状态：1-正常 0-禁用' })
  status: number;

  @Column({ type: 'datetime', nullable: true, comment: '入驻时间' })
  joined_at: Date;

  @CreateDateColumn({ type: 'datetime' })
  created_at: Date;

  @UpdateDateColumn({ type: 'datetime' })
  updated_at: Date;

  @Column({ type: 'datetime', nullable: true, comment: '最后登录时间' })
  last_login_at: Date;

  @Column({ type: 'varchar', length: 50, nullable: true, comment: '最后登录IP' })
  last_login_ip: string;

  @Column({ type: 'varchar', length: 100, nullable: true, comment: '最后登录地点' })
  last_login_location: string;

  @Column({ type: 'int', default: 0, comment: '连续登录失败次数' })
  login_fail_count: number;

  @Column({ type: 'datetime', nullable: true, comment: '锁定截止时间' })
  locked_until: Date;

  @Column({ type: 'tinyint', default: 0, comment: '软删除标记' })
  is_deleted: number;
}
