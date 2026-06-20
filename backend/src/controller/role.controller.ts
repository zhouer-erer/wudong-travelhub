import { Controller, Post, Get, Put, Del, Inject, Query, Body, Param } from '@midwayjs/decorator';
import { RoleService } from '../service/role.service';

/**
 * 角色控制器
 * 处理角色相关的 API 请求，包括角色的增删改查操作
 */
@Controller('/api/roles')
export class RoleController {
  @Inject()
  roleService: RoleService;

  /**
   * 获取角色列表（分页）
   * GET /api/roles/list
   * @param page - 页码，默认 1
   * @param pageSize - 每页数量，默认 20
   * @param keyword - 搜索关键词（可选）
   * @returns 分页角色列表
   */
  @Get('/list')
  async list(@Query('page') page = 1, @Query('pageSize') pageSize = 20, @Query('keyword') keyword?: string) {
    const result = await this.roleService.findAll(Number(page), Number(pageSize), keyword);
    return { code: 200, message: 'success', data: result };
  }

  /**
   * 获取角色详情
   * GET /api/roles/detail/:id
   * @param id - 角色 ID
   * @returns 角色详细信息
   */
  @Get('/detail/:id')
  async detail(@Param('id') id: number) {
    const item = await this.roleService.findById(Number(id));
    if (!item) return { code: 404, message: '不存在', data: null };
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 创建角色
   * POST /api/roles/create
   * @param body - 角色信息
   * @returns 创建后的角色信息
   */
  @Post('/create')
  async create(@Body() body: any) {
    const item = await this.roleService.create(body);
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 更新角色信息
   * PUT /api/roles/update/:id
   * @param id - 角色 ID
   * @param body - 更新的角色信息
   * @returns 更新后的角色信息
   */
  @Put('/update/:id')
  async update(@Param('id') id: number, @Body() body: any) {
    delete body.id;
    // 系统内置角色不允许修改 type 字段
    const existing = await this.roleService.findById(Number(id));
    if (existing && existing.type === 'system') {
      delete body.type;
    }
    const item = await this.roleService.update(Number(id), body);
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 删除角色
   * DELETE /api/roles/delete/:id
   * @param id - 角色 ID
   * @returns 操作结果
   */
  @Del('/delete/:id')
  async remove(@Param('id') id: number) {
    // 系统内置角色不允许删除
    const role = await this.roleService.findById(Number(id));
    if (role && role.type === 'system') {
      return { code: 403, message: '系统内置角色不允许删除', data: null };
    }
    await this.roleService.delete(Number(id));
    return { code: 200, message: 'success', data: null };
  }

  /**
   * 获取角色的权限列表
   * GET /api/roles/:id/permissions
   * @param id - 角色 ID
   * @returns 权限 ID 列表
   */
  @Get('/:id/permissions')
  async getPermissions(@Param('id') id: number) {
    const permIds = await this.roleService.getPermissionIds(Number(id));
    return { code: 200, message: 'success', data: permIds };
  }

  /**
   * 设置角色的权限
   * PUT /api/roles/:id/permissions
   * @param id - 角色 ID
   * @param body - { permissionIds: number[] }
   * @returns 操作结果
   */
  @Put('/:id/permissions')
  async setPermissions(@Param('id') id: number, @Body() body: any) {
    const permissionIds = body.permissionIds || [];
    await this.roleService.setPermissions(Number(id), permissionIds);
    return { code: 200, message: 'success', data: null };
  }
}
