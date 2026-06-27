# example

## 技术栈

`vue3` + `vue router` + `nuxt` + `tailwindcss`

## 代码样式，检查规范

`eslint`

## 代码管理与提交规范

`git` + `husky` + `lint-staged` + `commitlint`

| 项目       | 说明                                                                |
| ---------- | ------------------------------------------------------------------- |
| `build`    | 更改构建系统和外部依赖项（如将 gulp 改为 webpack，更新某个 npm 包） |
| `ci`       | 对 CI 配置文件和脚本的更改                                          |
| `docs`     | 仅仅修改文档说明                                                    |
| `feat`     | 增加一个新特性                                                      |
| `fix`      | 修复一个bug                                                         |
| `perf`     | 更改代码以提高性能                                                  |
| `refactor` | 代码重构                                                            |
| `revert`   | 回滚到上一个版本                                                    |
| `style`    | 不影响代码含义的改动，例如去掉空格、改变缩进、增删分号              |
| `test`     | 增加新的测试功能或更改原有的测试模块                                |
| `chore`    | 不属于以上类型的其他类型(日常事务)                                  |

查阅Nuxt文档 [Nuxt documentation](https://nuxt.com/docs/getting-started/introduction)

## 安装

安装依赖:

```bash
# pnpm
pnpm install
```

## 开发环境

`http://localhost:3000`:

```bash
# pnpm
pnpm dev
```

## 生产环境

编译:

```bash
# pnpm
pnpm build
```

预览:

```bash
# pnpm
pnpm preview
```

查阅发布文档 [deployment documentation](https://nuxt.com/docs/getting-started/deployment)
