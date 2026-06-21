import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
} from 'typeorm';

@Entity({ name: 'admin', comment: '管理员表' })
export class Admin {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 50, comment: '用户名' })
  username: string;

  @Column({ type: 'varchar', length: 255, comment: '密码（bcrypt加密）' })
  password_hash: string;

  @Column({ type: 'varchar', length: 50, comment: '姓名' })
  name: string;

  @Column({ type: 'varchar', length: 20, nullable: true, comment: '手机号' })
  phone: string;

  @Column({ type: 'varchar', length: 500, nullable: true, comment: '头像URL' })
  avatar: string;

  @Column({ type: 'int', comment: '角色ID' })
  role_id: number;

  @Column({ type: 'tinyint', default: 1, comment: '状态：1-启用 0-禁用' })
  status: number;

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

  @CreateDateColumn({ type: 'datetime' })
  created_at: Date;

  @UpdateDateColumn({ type: 'datetime' })
  updated_at: Date;

  @Column({ type: 'tinyint', default: 0, comment: '软删除标记' })
  is_deleted: number;
}
