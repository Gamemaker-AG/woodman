local coins = {}

local kleeblatt_img
local upgrades = {}
local upgrade_marked
local persisted_state


coins.load = function(state)
  persisted_state = state
  kleeblatt_img = love.graphics.newImage('assets/img/kleeblatt_dummy.png')
  nut_img = love.graphics.newImage('assets/img/nuss_dummy.png')
  back_img = love.graphics.newImage('assets/img/coins_back.png')
  table.insert(upgrades, {
    img = kleeblatt_img,
    header = 'Kleeblatt',
    get_function = savegame.get_cloverleaf,
    cost = 20,
    text = 'Das Kleeblatt erhöht dein Glück!\n(Äste tauchen häufiger auf derselben Seite auf)'
  })
  table.insert(upgrades, {
    img = nut_img,
    header = 'Nuss',
    get_function = savegame.get_nuts,
    cost = 10,
    text = 'Die Nuss lockt Eichhörnchen an, die zusätzliche Punkte geben!\nJede Nuss lockt 3 Eichhörnchen an.\nUm ein Eichhörnchen zu töten, drücke Space.'
  })
  table.insert(upgrades, {
    img = back_img,
    header = 'back',
    get_function = function() return 0 end,
    cost = '',
    text = ''
  })
  upgrade_marked = 1
end

coins.draw = function()
  love.graphics.setColor(0, 0, 0)
  love.graphics.print('Coins: ' .. savegame.getCoins(persisted_state), 20, 20)
  for index, upgrade in ipairs(upgrades) do
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(upgrade.img, 20, index*125-70)
    love.graphics.setColor(0, 0, 0)
    if(upgrade_marked == index) then
      love.graphics.setFont(semiLargeFont)
      love.graphics.print(upgrade.header, 140, index*125-40)
    else
      love.graphics.print(upgrade.header, 140, index*125-30)
    end
    love.graphics.setFont(normalFont)
    love.graphics.print('Du hast ' .. upgrade.get_function(persisted_state), 140, index*125-10)
    love.graphics.print(upgrade.cost .. ' Coins', 260, index*125-30)
    love.graphics.print(upgrade.text, 330, index*125-40)
  end
end

coins.keypressed = function(key)
  if key == 'return' then
    if upgrade_marked == table.getn(upgrades) then
      current_state = game_over_state
      game_over_state.load(persisted_state)
    elseif savegame.getCoins(persisted_state) >= upgrades[upgrade_marked].cost then
      savegame.add_coins(persisted_state, -upgrades[upgrade_marked].cost)
      if upgrades[upgrade_marked].header == 'Kleeblatt' then
        savegame.add_cloverleaf(persisted_state)
      elseif upgrades[upgrade_marked].header == 'nut' then
        savegame.add_nuts(persisted_state)
      end
      savegame.save(persisted_state)
    end
  elseif key == 'down' then
    if upgrade_marked < table.getn(upgrades) then
      upgrade_marked = upgrade_marked + 1
    elseif upgrade_marked == table.getn(upgrades) then
      upgrade_marked = 1
    end
  elseif key == 'up' then
    if upgrade_marked > 1 then
      upgrade_marked = upgrade_marked - 1
    elseif upgrade_marked == 1 then
      upgrade_marked = table.getn(upgrades)
    end
  end
end

coins.mousepressed = function(x, y, button, istouch)

end

return coins
