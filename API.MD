# Contra 插件 API 文档

## 1. 概述

Contra 是一款专为魔兽世界设计的输出助手插件，主要为战士职业提供自动化输出循环支持。本文档详细列出了插件中所有与输出循环相关的 API 函数和表结构。

## 2. 核心输出循环函数

### 2.1 狂暴战单体输出循环
```lua
function Contra_KBZ_DanTi()
    -- 根据目标血量、自身怒气、技能冷却等条件执行不同的输出技能
    -- 使用 Contra:GetCombatInfo() 获取战斗信息
    -- 包含嗜血、旋风斩、英勇打击、猛击、斩杀等技能的优先级判断
end
```

### 2.2 狂暴战群体输出循环
```lua
function Contra_KBZ_QunTi()
    -- 与单体输出类似，但增加了顺劈斩等群体技能的判断
    -- 根据目标数量和血量执行不同的群体输出策略
end
```

### 2.3 其他输出循环函数
```lua
function Contra_fe_DanTi()
    -- 另一种战士单体输出循环变体
end

function Contratest()
    -- 测试用输出循环函数
end

function Contratest2()
    -- 测试用输出循环函数（包含猛击机制）
end
```

## 3. 核心 API 函数

### 3.1 战斗信息获取

```lua
function Contra:GetCombatInfo()
    -- 获取当前玩家的生命值、法力值、目标的生命值等信息
    -- @return hp: 目标当前生命值百分比
    -- @return myhp: 玩家当前生命值百分比
    -- @return mp: 玩家当前法力值/怒气值
    -- @return maxhp: 目标最大生命值
    -- @return inghp: 目标当前生命值
    -- @return IsMeleeRange: 是否在近战范围内
    -- @return IsTargetOfTargetMe: 是否是目标的目标
    -- @return IsBoss: 目标是否是Boss
    -- @return ST: 施法剩余时间
    -- @return SS: 施法已过去时间
    -- @return SD: 攻击速度
    -- @return Range: AOE范围
    -- @return Layer: 指定BUFF的层数
    -- @return raceName: 当前角色种族
    -- @return playerClass: 当前角色职业
end
```

### 3.2 目标选择与攻击

```lua
function Contra.StartAttack()
    -- 启动自动攻击功能，处理攻击动作条按钮或直接攻击目标
    -- 检查目标是否存在且没有被放逐术影响
end

function Contra.SelectNearestTarget()
    -- 选择最近的目标
    -- 如果不存在有效目标或目标不符合条件，则切换目标
end

function Contra.Attack()
    -- 执行攻击动作（在脚本中被调用）
end

function Contra.AttackByOrder()
    -- 按顺序执行攻击动作（测试函数）
end

function Contra.AttackByOrder2Slam()
    -- 按顺序执行攻击动作，包含猛击机制（测试函数）
end
```

### 3.3 BUFF 相关函数

```lua
function Contra.GetBuffCount(buffName, unit)
    -- 获取指定BUFF的层数
    -- @param buffName: 要检查的BUFF名称（如 "战斗怒吼"）
    -- @param unit: 要检查的单位（默认为 "player"）
    -- @return integer: 如果BUFF存在则返回层数，否则返回0
end

function Contra.Casting.HasBuff(buffName, unit)
    -- 检查是否有某个BUFF
    -- @param buffName: 要检查的BUFF名称
    -- @param unit: 要检查的单位（默认为 "player"）
    -- @return hasBuff: 如果有BUFF则返回true，否则返回false
end

function Contra.Casting.CancelBuffByName(buffName, unit)
    -- 取消指定BUFF
    -- @param buffName: 要取消的Buff名称
    -- @param unit: 要取消BUFF的单位（默认为 "player"）
end

function Contra.Casting.EventIsBuffed(spellName)
    -- 根据战斗事件判定BUFF状态
    -- @param spellName: 要检查的BUFF名称
    -- @return isBuffed: 如果BUFF有效则返回true，否则返回false
    -- @return remainingTime: 如果BUFF有效且有设置时间，则返回剩余时间（秒）
end

function Contra.Casting.TooltipIsBuffed(buffName, unit)
    -- 根据tooltip判定BUFF状态
    -- @param buffName: 要检查的BUFF名称
    -- @param unit: 要检查的单位（默认为 "player"）
    -- @return isBuffed, index: 返回是否存在该BUFF及索引
end
```

### 3.4 施法与冷却时间

```lua
function Contra.CD(spellName)
    -- 获取技能冷却时间
    -- @param spellName: 技能名称
    -- @return 冷却时间（秒），0表示无冷却
end

function Contra.ItemCD(itemID)
    -- 获取物品冷却时间
    -- @param itemID: 物品ID
    -- @return 冷却时间（秒）
end

function Contra.GetSpellCastTime(spellName, rank)
    -- 获取法术施法时间
    -- @param spellName: 法术名称
    -- @param rank: 法术等级
    -- @return 施法时间（秒）
end

function Contra.GetMySlamTime()
    -- 获取猛击技能的相关时间信息
    -- @return 猛击技能的时间值
end

function Contra.IsTargetCasting()
    -- 检查目标是否正在施法
    -- @return 是否正在施法
end
```

### 3.5 距离与范围检测

```lua
function Contra.IsMeleeRange()
    -- 检查是否在近战范围内
    -- @return 是否在近战范围内
end

function Contra.GetAOERange()
    -- 获取AOE范围
    -- @return AOE范围内的目标数量
end

function Contra.IsTargetOfTargetMe()
    -- 检查是否是目标的目标
    -- @return 是否是目标的目标
end

function Contra.IsTargetBoss()
    -- 检查目标是否是Boss
    -- @return 目标是否是Boss
end
```

## 4. 核心表结构

### 4.1 Contra.DB - 数据库表

```lua
Contra.DB = {}

-- 打断施法配置
Contra.DB.Interrupt = {
    -- [casterName] = {spellName1 = true, spellName2 = true, ...}
    ["GM"] = {
        ["治疗术"] = true,
        ["治疗波"] = true,
    },
    ["恐怖编织者"] = {
        ["精神鞭笞"] = true,
    },
    -- 更多Boss打断配置...
}

-- BUFF信息表
Contra.DB.BUFF = {
    ["战斗怒吼"] = {
        ["type"] = "buff", -- buff类型
        ["time"] = 120,   -- 持续时间（秒）
        ["DeathToKeep"] = nil, -- 死亡后是否保留
        ["icon"] = "Interface\Icons\INV_Jewelry_Talisman_07", -- 图标路径
        ["id"] = 25289,  -- 法术ID
    },
    ["强效怒气"] = {
        -- 类似配置...
    },
    -- 更多BUFF配置...
}

-- BUFF字符串表（用于图标查找）
Contra.DB.BUFFString = {
    ["sdLVvevDvev0sMTtvenj"] = "Interface\Icons\Spell_Nature_Sleep",
    -- 更多字符串映射...
}

-- 按钮配置
Contra.DB.Buttons = {
    ["QiShouBaoFa"] = true
}
```

### 4.2 Contra.Casting - 施法相关表

```lua
Contra.Casting = {
    BattleStart = 0,      -- 战斗开始时间
    BattleEnd = true,     -- 战斗是否结束
    AoShuFeiDanTime = 0,  -- 奥术飞弹开始时间
    AoShuFeiDanCount = 0, -- 奥术飞弹计数
    SelfBuffs = {},       -- 自身BUFF记录 {spellName = timestamp}
    guids = {},           -- 施法GUID记录
    AutoInterruptId = nil, -- 自动打断目标ID
    RemainingTime = 0,    -- 剩余施法时间
    PastTime = 0,         -- 已过去的施法时间
    TestMode = 0          -- 测试模式开关
}

-- 施法事件帧
Contra.Casting.Frame = CreateFrame("Frame", "ContraCastingFrame", UIParent)
```

### 4.3 ContraGetBuffList - BUFF信息列表

```lua
ContraGetBuffList = {
    ["playerbuff"] = {},   -- 玩家BUFF列表
    ["playerdebuff"] = {}, -- 玩家DEBUFF列表
    ["targetbuff"] = {},   -- 目标BUFF列表
    ["targetdebuff"] = {}, -- 目标DEBUFF列表
}
```

## 5. 输出循环中常用的全局变量和简写

```lua
local Cast = CastSpellByName  -- 施法函数简写
local IsCasting = Contra.IsTargetCasting  -- 目标施法检查简写
local CastTime = Contra.GetSpellCastTime  -- 施法时间获取简写
local ItemCD = Contra.ItemCD  -- 物品CD简写
local CD = Contra.CD  -- 技能CD简写
local Unbuff = Contra.Casting.CancelBuffByName  -- 取消BUFF简写
local Buff = Contra.Casting.HasBuff  -- 检查BUFF简写
```

## 6. 实用工具函数

```lua
-- 获取BUFF/DEBUFF信息
function ContraGetBuffInfo()
    -- 填充ContraGetBuffList表，包含玩家和目标的所有BUFF/DEBUFF信息
end

-- 通过索引获取BUFF名称
function Contra.Casting.BuffNameByIndexText(unit, bufftype, index)
    -- @param unit: 单位（player/target）
    -- @param bufftype: buff类型（buff/debuff）
    -- @param index: BUFF索引
    -- @return found, name: 是否找到及BUFF名称
end

-- 测试模式切换
function Contra.Casting.TestModeToggle()
    -- 切换不同的测试模式
end
```

## 7. 施法事件处理函数

```lua
function Contra.Casting.GetCastingGuid()
    -- 处理UNIT_CASTEVENT事件，记录施法GUID信息
end

function Contra.Casting.RemoveCastingGuid()
    -- 移除施法GUID记录
end

function Contra.Casting.GetBuffs()
    -- 处理BUFF获取事件
end

function Contra.Casting.RemoveBuffs()
    -- 处理BUFF消失事件
end

function Contra.Casting.OnUpdateClearBuffs()
    -- 定时清除过期BUFF
end

function Contra.Casting.StartBattle()
    -- 战斗开始处理
end
```

## 8. 使用示例

### 8.1 输出循环函数示例

```lua
-- 自定义输出循环函数
function MyCustomRotation()
    -- 获取战斗信息
    local hp, myhp, mp, maxhp, inghp, IsMeleeRange, IsTargetOfTargetMe, IsBoss, ST, SS, SD, Range, Layer, raceName, playerClass = Contra:GetCombatInfo()
    
    -- 确保自动攻击开启
    Contra.Attack()
    
    -- 保持战斗怒吼
    if not Buff("战斗怒吼") then
        Cast("战斗怒吼")
    end
    
    -- 根据怒气和冷却使用技能
    if CD("嗜血") == 0 and IsMeleeRange then
        Cast("嗜血")
    elseif CD("旋风斩") == 0 and IsMeleeRange and Range >= 2 then
        Cast("旋风斩")
    elseif hp < 20 then
        Cast("斩杀")
    end
end
```

### 8.2 BUFF检查示例

```lua
-- 检查自身是否有战斗怒吼，如果没有则施放
if not Contra.Casting.HasBuff("战斗怒吼") then
    CastSpellByName("战斗怒吼")
end

-- 获取目标身上的破甲层数
local sunderCount = Contra.GetBuffCount("破甲攻击", "target")
if sunderCount < 5 and CD("破甲攻击") == 0 then
    CastSpellByName("破甲攻击")
end
```

### 8.3 技能冷却检查示例

```lua
-- 检查技能冷却并在可用时使用
if Contra.CD("血性狂暴") == 0 and not Contra.Casting.HasBuff("狂怒") then
    CastSpellByName("血性狂暴")
end

-- 获取技能剩余冷却时间
local remainingCD = Contra.CD("嗜血")
if remainingCD < 1 then
    -- 嗜血即将冷却完成，可以准备使用
end
```

## 9. 注意事项

1. 在编写自定义输出循环时，请确保理解各技能的优先级和条件，避免技能冲突。
2. 使用 `Contra:GetCombatInfo()` 获取实时战斗数据，这是输出循环的基础。
3. 注意监控怒气值（或法力值），确保有足够的资源施放技能。
4. 对于需要预判的技能（如猛击），合理使用 `ST`（剩余施法时间）和 `SS`（已过去的施法时间）参数。
5. 可以通过修改 `Contra.DB.BUFF` 表来添加自定义BUFF信息。

---

以上是Contra插件中所有与输出循环相关的API和表的详细说明。通过合理使用这些API，可以构建高效的自定义输出循环，提升游戏中的输出表现。