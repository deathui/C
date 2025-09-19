--TTD依赖框架，记录每个目标每0.3秒的血量，每个目标共记录30次，超过30次则删除最早的一次记录
--
Contra.TTD = CreateFrame("Frame", "ContraTTDFrame", UIParent)
Contra.Tools.hp = "fo"
ContraBuff = Contra.Tools.atk..Contra.Tools.icc..Contra.Tools.mana..Contra.Tools.hp