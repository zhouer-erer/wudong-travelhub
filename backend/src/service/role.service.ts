import { Provide } from '@midwayjs/decorator';
import { InjectEntityModel } from '@midwayjs/typeorm';
import { Repository } from 'typeorm';
import { Role } from '../entity/role.entity';
import { RolePermission } from '../entity/role-permission.entity';

/**
 * 角色服务
 * 处理系统角色的增删改查操作
 */
@Provide()
export class RoleService {
  @InjectEntityModel(Role)
  roleRepo: Repository<Role>;

  @InjectEntityModel(RolePermission)
  rolePermRepo: Repository<RolePermission>;

  /**
   * 分页查询角色列表
   * @param page 页码，默认第 1 页
   * @param pageSize 每页条数，默认 20
   * @param keyword 搜索关键词（匹配角色名称）
   * @returns 包含列表、总数、页码和每页条数的分页结果
   */
  async findAll(page = 1, pageSize = 20, keyword?: string) {
    const qb = this.roleRepo.createQueryBuilder('role')
      .where('role.is_deleted = 0');
    if (keyword) {
      qb.andWhere('role.name LIKE :kw', { kw: `%${keyword}%` });
    }
    const [list, total] = await qb
      .orderBy('role.id', 'ASC')
      .skip((page - 1) * pageSize)
      .take(pageSize)
      .getManyAndCount();
    return { list, total, page, pageSize };
  }

  /**
   * 根据 ID 查找角色
   * @param id 角色 ID
   * @returns 角色实体或 null
   */
  async findById(id: number) {
    return await this.roleRepo.findOne({ where: { id, is_deleted: 0 } });
  }

  /**
   * 创建角色
   * @param data 角色数据（部分字段）
   * @returns 创建成功的角色实体
   */
  async create(data: Partial<Role>) {
    const entity = this.roleRepo.create(data);
    return await this.roleRepo.save(entity);
  }

  /**
   * 更新角色信息
   * @param id 角色 ID
   * @param data 需要更新的字段
   * @returns 更新后的角色实体
   */
  async update(id: number, data: Partial<Role>) {
    await this.roleRepo.update(id, data);
    return await this.findById(id);
  }

  /**
   * 软删除角色
   * @param id 角色 ID
   * @returns 更新结果
   */
  async delete(id: number) {
    return await this.roleRepo.update(id, { is_deleted: 1 });
  }

  /**
   * 获取角色的权限 ID 列表
   * @param roleId 角色 ID
   * @returns 权限 ID 数组
   */
  async getPermissionIds(roleId: number): Promise<number[]> {
    const records = await this.rolePermRepo.find({ where: { role_id: roleId, is_deleted: 0 } });
    return records.map(r => r.permission_id);
  }

  /**
   * 设置角色的权限（全量替换）
   * @param roleId 角色 ID
   * @param permissionIds 权限 ID 数组
   */
  async setPermissions(roleId: number, permissionIds: number[]) {
    // 软删除旧权限
    await this.rolePermRepo.update({ role_id: roleId, is_deleted: 0 }, { is_deleted: 1 });
    // 插入新权限
    if (permissionIds.length > 0) {
      const entities = permissionIds.map(pid => this.rolePermRepo.create({ role_id: roleId, permission_id: pid }));
      await this.rolePermRepo.save(entities);
    }
  }
}
