import { Provide, Inject } from '@midwayjs/decorator';
import { InjectEntityModel } from '@midwayjs/typeorm';
import { Repository } from 'typeorm';
import { Permission } from '../entity/permission.entity';
import { RolePermission } from '../entity/role-permission.entity';
import { RedisService } from './redis.service';

/**
 * 权限服务
 * 处理权限的增删改查、权限树构建及角色权限分配操作
 */
@Provide()
export class PermissionService {
  @InjectEntityModel(Permission)
  permissionRepo: Repository<Permission>;

  @InjectEntityModel(RolePermission)
  rolePermissionRepo: Repository<RolePermission>;

  @Inject()
  redisService: RedisService;

  /**
   * 分页查询权限列表
   * @param page 页码，默认第 1 页
   * @param pageSize 每页条数，默认 20
   * @param keyword 搜索关键词（匹配权限名称或权限编码）
   * @returns 包含列表、总数、页码和每页条数的分页结果
   */
  async findAll(page = 1, pageSize = 20, keyword?: string) {
    const qb = this.permissionRepo.createQueryBuilder('permission')
      .where('permission.is_deleted = 0');
    if (keyword) {
      qb.andWhere('(permission.name LIKE :kw OR permission.code LIKE :kw)', { kw: `%${keyword}%` });
    }
    const [list, total] = await qb
      .orderBy('permission.sort_order', 'ASC')
      .addOrderBy('permission.id', 'ASC')
      .skip((page - 1) * pageSize)
      .take(pageSize)
      .getManyAndCount();
    return { list, total, page, pageSize };
  }

  /**
   * 根据 ID 查找权限
   * @param id 权限 ID
   * @returns 权限实体或 null
   */
  async findById(id: number) {
    return await this.permissionRepo.findOne({ where: { id, is_deleted: 0 } });
  }

  /**
   * 根据角色 ID 查找关联的权限列表
   * 超级管理员（name='超级管理员' 且 type='system'）默认拥有全部权限
   * @param roleId 角色 ID
   * @returns 权限实体数组
   */
  async findByRoleId(roleId: number) {
    // 超级管理员直接返回全部权限
    const role = await this.rolePermissionRepo.manager.getRepository('role').findOne({ where: { id: roleId } });
    if (role && role.name === '超级管理员' && role.type === 'system') {
      return await this.permissionRepo.find({
        where: { is_deleted: 0 },
        order: { sort_order: 'ASC', id: 'ASC' },
      });
    }

    const rolePermissions = await this.rolePermissionRepo.find({ where: { role_id: roleId } });
    if (rolePermissions.length === 0) {
      return [];
    }
    const permissionIds = rolePermissions.map(rp => rp.permission_id);
    return await this.permissionRepo.createQueryBuilder('permission')
      .where('permission.id IN (:...permissionIds)', { permissionIds })
      .andWhere('permission.is_deleted = 0')
      .orderBy('permission.sort_order', 'ASC')
      .getMany();
  }

  /**
   * 创建权限
   * @param data 权限数据（部分字段）
   * @returns 创建成功的权限实体
   */
  async create(data: Partial<Permission>) {
    const entity = this.permissionRepo.create(data);
    return await this.permissionRepo.save(entity);
  }

  /**
   * 更新权限信息
   * @param id 权限 ID
   * @param data 需要更新的字段
   * @returns 更新后的权限实体
   */
  async update(id: number, data: Partial<Permission>) {
    await this.permissionRepo.update(id, data);
    return await this.findById(id);
  }

  /**
   * 软删除权限
   * @param id 权限 ID
   * @returns 更新结果
   */
  async delete(id: number) {
    return await this.permissionRepo.update(id, { is_deleted: 1 });
  }

  /**
   * 获取权限树结构
   * @returns 以树形结构组织的权限列表（含 children 子节点）
   */
  async getPermissionTree() {
    const all = await this.permissionRepo.find({
      where: { is_deleted: 0, status: 1 },
      order: { sort_order: 'ASC', id: 'ASC' },
    });
    return this.buildTree(all, 0);
  }

  /**
   * 获取权限树结构（别名方法）
   * @returns 以树形结构组织的权限列表
   */
  async getTree() {
    return this.getPermissionTree();
  }

  /**
   * 设置角色权限（先清除原有权限再重新分配）
   * @param roleId 角色 ID
   * @param permissionIds 权限 ID 列表
   * @returns 包含影响行数的结果对象
   */
  async setRolePermissions(roleId: number, permissionIds: number[]) {
    await this.rolePermissionRepo.delete({ role_id: roleId });
    if (permissionIds.length === 0) {
      // 清除 RBAC 缓存
      await this.invalidatePermissionCache(roleId);
      return { affected: 0 };
    }
    const entities = permissionIds.map(pid =>
      this.rolePermissionRepo.create({ role_id: roleId, permission_id: pid })
    );
    const result = await this.rolePermissionRepo.save(entities);
    // 清除 RBAC 缓存
    await this.invalidatePermissionCache(roleId);
    return { affected: result.length };
  }

  /**
   * 清除角色权限的 Redis 缓存
   * 当角色权限变更时调用，确保下次请求从 DB 获取最新权限
   * @param roleId 角色 ID
   */
  private async invalidatePermissionCache(roleId: number): Promise<void> {
    try {
      await this.redisService.del(`rbac:permissions:${roleId}`);
    } catch {
      // Redis 异常不影响主业务
    }
  }

  /**
   * 递归构建权限树
   * @param list 全部权限列表
   * @param parentId 父级权限 ID
   * @returns 树形权限节点数组
   */
  private buildTree(list: Permission[], parentId: number): any[] {
    return list
      .filter(p => p.parent_id === parentId)
      .map(p => ({
        ...p,
        children: this.buildTree(list, p.id),
      }));
  }
}
