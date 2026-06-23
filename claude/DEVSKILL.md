# Frontend Development Skill

你是一个资深前端架构师，负责开发当前项目。

---

## 技术栈

- **React 18** - 使用函数组件 + Hooks
- **TypeScript** - 严格类型检查
- **Vite** - 构建工具
- **TailwindCSS + SCSS** - 样式方案
- **MobX 6** - 状态管理（observer 模式）
- **React Router 7** - 路由管理
- **Ant Design 6** - UI 组件库

---

## 项目架构

### 整体结构

```
src/
├── features/         # 功能模块（Feature-based）
├── shared/           # 共享资源
├── router/           # 路由配置
└── static/           # 基础页面（NotFound、agreements 等）
```

### 核心理念

**Feature-based Architecture**：按业务功能组织代码，每个 feature 是一个完整的业务单元

**UI/业务完全解耦**：2 层核心架构 + 2 层支持层

---

## 目录结构详解

### 1. features/ - 功能模块

每个功能模块是独立的业务单元，遵循统一的内部结构：

```
feature-name/
├── ui/                # ✅ 必需：UI 组件
│   ├── PageName.tsx   # 页面入口组件
│   ├── components/    # 子组件（按需嵌套）
│   └── index.ts       # 导出
├── stores/            # ✅ 必需：状态管理
│   ├── featureStore.ts
│   └── index.ts
├── services/          # 📦 可选：有后端交互时添加
│   ├── types.ts       # 类型定义（先写类型）
│   ├── featureService.ts
│   └── index.ts
├── domain/            # 📦 可选：有复杂业务规则时添加
│   ├── dataAdapter.ts
│   └── index.ts
└── index.ts           # ✅ 必需：feature 统一出口
```

#### 层级说明

**✅ 必需层**（所有 feature 必须有）：

- `ui/` - UI 组件
- `stores/` - MobX 状态管理
- `index.ts` - 统一导出

**📦 可选层**（按需添加）：

- `services/` - 有后端交互时添加
- `domain/` - 有复杂业务规则时添加

---

### 2. shared/ - 共享资源

跨 feature 共享的代码：

```
shared/
├── ui/                # 共享 UI 组件
│   ├── Header/
│   ├── Layout/
│   ├── VideoCard/
│   └── index.ts
├── stores/            # 全局状态（用户、应用配置等）
│   ├── userStore.ts
│   ├── AppStore.ts
│   └── index.ts
├── hooks/             # 共享 hooks（如 useAuth）
├── api/               # API 基础设施（request、configUrl）
├── utils/             # 工具函数
├── config/            # 全局配置
└── index.ts
```

---

## 架构设计

### 2 层核心 + 2 层支持

```
┌─────────────────────────────────┐
│         UI Layer                 │  ✅ 核心层 1
│  (组件、JSX、TailwindCSS)        │  纯展示，只负责渲染
└─────────────────────────────────┘
              ↓ 直接访问（MobX observer）
┌─────────────────────────────────┐
│       Store Layer                │  ✅ 核心层 2
│  (MobX observable、action)       │  状态管理 + 业务协调
└─────────────────────────────────┘
              ↓ Store 调用
┌─────────────────────────────────┐
│      Service Layer               │  📦 支持层 1（可选）
│  (API 调用 + 业务流程编排)        │  接口封装、业务编排
└─────────────────────────────────┘
              ↓ Service 使用
┌─────────────────────────────────┐
│      Domain Layer                │  📦 支持层 2（可选）
│  (纯函数、业务规则、数据转换)     │  可复用的业务逻辑
└─────────────────────────────────┘
```

---

## 各层职责详解

### 1. ui/ - UI 组件层

**职责**：

- 页面布局和组件拼装
- TailwindCSS + SCSS 样式
- 交互动画
- 事件处理（只调用 store 方法）

**允许**：

```tsx
// ✅ 导入和使用 MobX store
import { observer } from 'mobx-react-lite';
import videoGenerationStore from '../stores/videoGenerationStore';

// ✅ 使用 observer 包裹组件（响应式更新）
const VideoEditor = observer(() => {
  // ✅ 在 useEffect 中初始化 store
  useEffect(() => {
    videoGenerationStore.init();
  }, []);

  // ✅ 直接访问 store 状态
  const { modelList, isLoading } = videoGenerationStore;

  // ✅ 事件处理中调用 store 方法
  const handleDelete = (id: string) => {
    videoGenerationStore.deleteVideoTask(id);
  };

  return <div>...</div>;
});
```

**禁止**：

```tsx
// ❌ 直接调用 API
import request from '@/shared/api/request';
const res = await request.get('/api/video/config');

// ❌ 直接写业务逻辑
const processData = (data) => {
  // 复杂的数据转换和业务判断...
};

// ❌ 在组件内部修改 store（应该调用 store 的 action）
videoGenerationStore.modelList = [...]; // ❌
videoGenerationStore.setModelList([...]); // ✅
```

---

### 2. stores/ - 状态管理层

**职责**：

- MobX 状态管理
- 调用 service 层（不直接调用 API）
- 业务流程协调

**推荐模式**：

```typescript
import { makeAutoObservable, runInAction } from 'mobx';
import * as videoService from '../services/videoGenerationService';

class VideoGenerationStore {
  // 📊 状态
  modelList: ModelInfo[] = [];
  isLoading = false;
  error: string | null = null;
  private initialized = false;

  constructor() {
    makeAutoObservable(this);
  }

  // 🧮 计算属性
  getModelById = (id: string) => {
    return this.modelList.find(m => m.id === id);
  };

  // 🎬 Actions

  /**
   * 初始化（UI 层在 useEffect 中调用）
   */
  init = async () => {
    if (!this.initialized && !this.isLoading) {
      this.initialized = true;
      await this.fetchConfig();
    }
  };

  /**
   * 获取配置（调用 service，不直接调用 API）
   */
  fetchConfig = async () => {
    if (this.isLoading) return;

    runInAction(() => {
      this.isLoading = true;
      this.error = null;
    });

    try {
      // ✅ 调用 service 层
      const data = await videoService.loadVideoConfig();

      runInAction(() => {
        this.modelList = data.modelList;
        this.isLoading = false;
      });
    } catch (error) {
      runInAction(() => {
        this.error = (error as Error).message;
        this.isLoading = false;
      });
    }
  };

  /**
   * 删除任务
   */
  deleteTask = async (taskId: string): Promise<boolean> => {
    // ✅ 调用 service 层
    return await videoService.removeVideoTask(taskId);
  };

  // 🔄 重置
  reset = () => {
    this.modelList = [];
    this.isLoading = false;
    this.error = null;
    this.initialized = false;
  };
}

// 导出单例
const videoGenerationStore = new VideoGenerationStore();
export default videoGenerationStore;
```

**允许**：

- `observable` - 定义状态
- `computed` - 计算属性
- `action` - 修改状态的方法
- 调用 `services/` 层的函数

**禁止**：

- ❌ 直接调用 API（应该通过 service 层）
- ❌ 写 JSX 代码
- ❌ 导入 UI 组件

---

### 3. services/ - 服务层（可选）

**职责**：

- API 调用
- 业务流程编排
- 数据转换
- 错误处理

**推荐模式**：

```typescript
import request from '@/shared/api/request';
import configUrl from '@/shared/api/configUrl';
import { message } from 'antd';
import type { ModelInfo, VideoConfigData } from './types';

// ==================== API 调用（私有） ====================

/**
 * 获取视频配置（API 调用）
 */
const fetchVideoConfigApi = async (): Promise<any> => {
  const res = await request.get(configUrl.videoConfig);
  return res;
};

/**
 * 删除任务（API 调用）
 */
const deleteTaskApi = async (taskId: string): Promise<void> => {
  await request.post(configUrl.videoTaskDelete, { taskId }, { dataIsJson: true });
};

// ==================== 业务逻辑（导出） ====================

/**
 * 加载视频配置
 * 业务流程: API 调用 → 数据转换 → 错误处理
 */
export const loadVideoConfig = async (): Promise<VideoConfigData> => {
  try {
    // 1. 调用 API
    const res = await fetchVideoConfigApi();

    // 2. 数据转换
    const root = res?.data ?? {};
    const models = root.modelList?.list ?? [];
    const effects = root.effectPlayList?.list ?? [];

    // 3. 返回业务数据
    return {
      modelList: models,
      effectPlayList: effects,
    };
  } catch (error: any) {
    // 4. 错误处理
    const msg = error?.msg ?? error?.message ?? '加载失败';
    message.error(msg);
    throw new Error(msg);
  }
};

/**
 * 删除视频任务
 * 业务流程: 参数校验 → API 调用 → 成功提示 → 错误处理
 */
export const removeVideoTask = async (taskId: string): Promise<boolean> => {
  // 1. 参数校验
  if (!taskId) {
    message.warning('缺少任务 ID');
    return false;
  }

  try {
    // 2. 调用 API
    await deleteTaskApi(taskId);

    // 3. 成功提示
    message.success('删除成功');
    return true;
  } catch (error: any) {
    // 4. 错误处理
    const msg = error?.msg ?? error?.message ?? '删除失败';
    message.error(msg);
    return false;
  }
};
```

**模式说明**：

- **私有 API 函数**：不导出，只在文件内部使用
- **公共业务函数**：导出给 store 层调用
- **统一错误处理**：在 service 层处理，不向上抛出
- **用户提示**：在 service 层完成（message.success/error）

---

### 4. domain/ - 领域层（可选）

**职责**：

- 纯函数业务规则
- 数据转换和适配
- 参数校验
- 状态判断

**推荐模式**：

```typescript
// modelInfoAdapter.ts - 数据转换适配器

import type { ModelInfo } from '../services/types';
import type { VideoModel, VideoConfig, VideoConfigOptions } from '../ui/...';

/**
 * 将后端 ModelInfo 转换为 UI 层的 VideoModel
 */
export function modelInfoToVideoModel(info: ModelInfo): VideoModel {
  return {
    id: info.id,
    name: info.name,
    description: info.description,
    icon: info.icon,
  };
}

/**
 * 提取 ModelInfo 的配置选项
 */
export function modelInfoToConfigOptions(info: ModelInfo): VideoConfigOptions {
  return {
    ratios: [...info.ratios],
    resolutions: [...info.resolutions],
    durationRange: { min: info.durationMin, max: info.durationMax },
    counts: [...info.counts],
  };
}

/**
 * 获取 ModelInfo 的默认配置
 */
export function defaultVideoConfigFromModelInfo(info: ModelInfo): VideoConfig {
  return {
    ratio: info.ratios[0],
    resolution: info.resolutions[0],
    duration: info.durationMin,
    count: info.counts[0],
  };
}

/**
 * 将配置限制在模型允许的范围内
 */
export function clampVideoConfig(config: VideoConfig, info: ModelInfo): VideoConfig {
  const opts = modelInfoToConfigOptions(info);
  return {
    ratio: opts.ratios.includes(config.ratio) ? config.ratio : opts.ratios[0],
    resolution: opts.resolutions.includes(config.resolution)
      ? config.resolution
      : opts.resolutions[0],
    duration: Math.min(
      Math.max(config.duration, opts.durationRange.min),
      opts.durationRange.max
    ),
    count: opts.counts.includes(config.count) ? config.count : opts.counts[0],
  };
}
```

**特点**：

- ✅ 纯函数（无副作用）
- ✅ 可测试
- ✅ 可复用
- ❌ 不调用 API
- ❌ 不修改全局状态
- ❌ 不依赖 UI 组件

---

## 使用模式

### MobX Observer 模式（无 hooks 层）

组件直接使用 `observer` 访问 store，不需要中间的 hooks 层：

```tsx
// ✅ 推荐：直接使用 observer
import { observer } from 'mobx-react-lite';
import videoGenerationStore from '../stores/videoGenerationStore';

const VideoEditor = observer(() => {
  useEffect(() => {
    // 初始化 store
    videoGenerationStore.init();
  }, []);

  // 直接访问 store（自动响应式更新）
  return (
    <div>
      {videoGenerationStore.isLoading ? (
        <Loading />
      ) : (
        <VideoList data={videoGenerationStore.modelList} />
      )}
    </div>
  );
});

// ❌ 不推荐：创建中间 hooks 层（过度设计）
function useVideoConfig() {
  return {
    modelList: videoGenerationStore.modelList,
    isLoading: videoGenerationStore.isLoading,
    fetchConfig: videoGenerationStore.fetchConfig,
  };
}
```

### 何时使用 observer？

- **需要响应式更新**：组件需要在 store 状态变化时自动重新渲染
- **访问多个状态**：组件使用 store 的多个 observable 属性

```tsx
// ✅ 需要 observer（访问状态）
const VideoList = observer(() => {
  const { modelList, isLoading } = videoGenerationStore;
  return <div>{modelList.map(...)}</div>;
});

// ✅ 不需要 observer（只调用方法）
const DeleteButton = ({ id }: { id: string }) => {
  const handleClick = () => {
    videoGenerationStore.deleteTask(id);
  };
  return <button onClick={handleClick}>删除</button>;
};
```

---

## 导出规范

### Feature 导出（index.ts）

```typescript
// features/video-generation/index.ts

// UI 组件（页面）
export { default as VideoGenerationPage } from './ui/VideoGenerationPage';
export { default as GenerateVideoEditor } from './ui/GenerateVideoEditor';
export { default as GenerateResult } from './ui/GenerateResult';

// Store（直接在组件中使用，配合 observer）
export { default as videoGenerationStore } from './stores/videoGenerationStore';

// Services（如果需要在其他 feature 复用）
export * from './services';

// Domain（纯函数，可复用）
export * from './domain';
```

### Shared 导出（index.ts）

```typescript
// shared/index.ts

// UI 组件
export * from './ui';

// Store
export * from './stores';

// Utils
export * from './utils';

// Hooks
export * from './hooks';
```

---

## 开发流程

### 1. 新增功能模块

```bash
# 创建基础结构
features/
└── new-feature/
    ├── ui/
    │   ├── NewFeaturePage.tsx    # 页面组件
    │   └── index.ts
    ├── stores/
    │   ├── newFeatureStore.ts    # 状态管理
    │   └── index.ts
    └── index.ts                   # 统一导出
```

### 2. 添加后端交互

如果需要调用接口，添加 `services/` 层：

```bash
features/new-feature/
├── services/
│   ├── types.ts              # 类型定义
│   ├── newFeatureService.ts  # 业务逻辑
│   └── index.ts
```

### 3. 添加复杂业务规则

如果有可复用的纯函数逻辑，添加 `domain/` 层：

```bash
features/new-feature/
├── domain/
│   ├── dataAdapter.ts        # 数据转换
│   ├── validator.ts          # 参数校验
│   └── index.ts
```

---

## 最佳实践

### ✅ DO（推荐）

1. **单一职责**
  - UI 只负责展示
  - Store 只管理状态
  - Service 只做业务编排
  - Domain 只写纯函数
2. **类型安全**
  ```typescript
   // ✅ 完整的类型定义
   export type ModelInfo = {
     id: string;
     name: string;
     ratios: Array<'9:16' | '1:1' | '16:9'>;
   };
  ```
3. **统一导出**
  ```typescript
   // ✅ 每个目录都有 index.ts
   export * from './ui';
   export * from './stores';
  ```
4. **错误处理**
  ```typescript
   // ✅ 在 service 层统一处理
   try {
     const data = await fetchApi();
     return data;
   } catch (error) {
     message.error('操作失败');
     throw error;
   }
  ```
5. **MobX 响应式更新**
  ```typescript
   // ✅ 使用 runInAction 批量更新状态
   runInAction(() => {
     this.isLoading = false;
     this.data = result;
   });
  ```

### ❌ DON'T（禁止）

1. **跨层调用**
  ```typescript
   // ❌ UI 直接调用 API
   const res = await request.get('/api/...');

   // ❌ Store 依赖 UI 组件
   import Button from '../ui/Button';
  ```
2. **循环依赖**
  ```typescript
   // ❌ feature A 依赖 feature B，feature B 又依赖 feature A
   import { videoStore } from '@/features/video-generation';
   import { imageStore } from '@/features/image-generation';
  ```
3. **全局状态滥用**
  ```typescript
   // ❌ 把所有状态都放在 shared/stores
   // ✅ 只有真正全局的状态（用户信息、应用配置等）才放 shared
  ```
4. **过度抽象**
  ```typescript
   // ❌ 简单的逻辑不需要 domain 层
   // 只有可复用、有复杂业务规则的才需要 domain
  ```

---

## 代码规范

### TypeScript

- 使用严格模式
- 所有导出必须有类型
- 避免使用 `any`（除非确实需要）

### 命名规范

- **组件**：PascalCase（`VideoCard.tsx`）
- **函数/变量**：camelCase（`fetchConfig`, `modelList`）
- **类型**：PascalCase（`ModelInfo`, `VideoConfig`）
- **常量**：UPPER_SNAKE_CASE（`MAX_COUNT`）
- **私有函数**：camelCase + 不导出（`fetchVideoConfigApi`）

### 文件组织

```
feature/
├── ui/
│   ├── ComponentA/
│   │   ├── index.tsx
│   │   └── index.scss
│   ├── ComponentB.tsx
│   └── index.ts
├── stores/
│   ├── featureStore.ts
│   └── index.ts
├── services/
│   ├── types.ts          # 类型优先
│   ├── featureService.ts
│   └── index.ts
└── index.ts
```

---

## 常见问题

### Q1: 什么时候需要 services 层？

**A**: 当 feature 需要调用后端接口时。如果只是纯前端展示（如 creation-tools、inspiration-center），则不需要。

### Q2: domain 层和 services 层有什么区别？

**A**:

- **services**：有副作用（API 调用、message 提示、抛出错误）
- **domain**：纯函数（无副作用，可测试，可复用）

### Q3: 为什么不用 hooks 层？

**A**: MobX 的 `observer` 模式已经提供了响应式更新，不需要额外的 hooks 层。简单的访问器 hooks 是过度设计。

### Q4: 如何在不同 feature 之间共享代码？

**A**:

- **UI 组件** → 移到 `shared/ui/`
- **工具函数** → 移到 `shared/utils/`
- **类型定义** → 移到 `shared/types/`
- **业务逻辑** → 考虑是否真的需要共享，避免强耦合

### Q5: Store 应该直接调用 API 吗？

**A**: ❌ 不应该。Store 应该调用 service 层，保持单一职责：

```typescript
// ❌ 不好
class Store {
  fetch = async () => {
    const res = await request.get('/api/...');  // 直接调API
  }
}

// ✅ 推荐
class Store {
  fetch = async () => {
    const data = await videoService.loadConfig();  // 调service
  }
}
```

---

## 总结

### 核心原则

1. **Feature-based** - 按业务功能组织代码
2. **层次分明** - UI / Store / Service / Domain 职责清晰
3. **依赖方向** - UI → Store → Service → Domain（单向依赖）
4. **类型安全** - TypeScript 严格模式
5. **可测试性** - 纯函数优先，业务逻辑独立

### 目录结构一览

```
src/
├── features/                # 功能模块
│   └── feature-name/
│       ├── ui/              # ✅ UI 组件（必需）
│       ├── stores/          # ✅ 状态管理（必需）
│       ├── services/        # 📦 API + 业务（可选）
│       ├── domain/          # 📦 纯函数（可选）
│       └── index.ts         # ✅ 统一导出（必需）
├── shared/                  # 共享资源
│   ├── ui/                  # 共享组件
│   ├── stores/              # 全局状态
│   ├── hooks/               # 共享 hooks
│   ├── api/                 # API 基础设施
│   ├── utils/               # 工具函数
│   └── config/              # 全局配置
├── router/                  # 路由配置
└── static/                  # 基础页面

```

---

**版本**: v1.0
**最后更新**: 2026-05-09
**架构**: 2 层核心（UI + Store）+ 2 层支持（Service + Domain）