local coins = {}

local kleeblatt_img
local number_coins
local upgrades = {}
local upgrade_marked
local persisted_state


coins.load = function(state)
  persisted_state = state
  kleeblatt_img = love.graphics.newImage('img/kleeblatt_dummy.png')
  nuss_img = love.graphics.newImage('img/nuss_dummy.png')
  back_img = love.graphics.newImage('img/coins_back.png')
  number_coins = 60
  table.insert(upgrades, {
    img = kleeblatt_img,
    header = 'Kleeblatt',
    cost = 20,
    text = 'Das Kleeblatt erhöht dein Glück!\n(Äste tauchen häufiger auf derselben Seite auf)'
  })
  table.insert(upgrades, {
    img = nuss_img,
    header = 'Nuss',
    cost = 10,
    text = 'Die Nuss lockt Eichhörnchen an, die zusätzliche Punkte geben!\nJede Nuss lockt 3 Eichhörnchen an.\nUm ein Eichhörnchen zu töten, drücke Space.'
  })
  table.insert(upgrades, {
    img = back_img,
    header = 'back',
    cost = '',
    text = ''
  })
  upgrade_marked = 1
end

coins.draw = function()
  love.graphics.setColor(0, 0, 0)
  love.graphics.print('Coins: ' .. number_coins, 20, 20)
  for index, upgrade in ipairs(upgrades) do
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(upgrade.img, 20, index*125-70)
    love.graphics.setColor(0, 0, 0)
    if(upgrade_marked == index) then
      love.graphics.setFont(semiLargeFont)
      love.graphics.print(upgrade.header, 140, index*125-35)
    else
      love.graphics.print(upgrade.header, 140, index*125-30)
    end
    love.graphics.setFont(normalFont)
    love.graphics.print(upgrade.cost, 260, index*125-30)
    love.graphics.print(upgrade.text, 300, index*125-40)
  end
  love.graphics.print(kleeblatt, 5, 5)
end

coins.addCoin = function()
  number_coins = number_coins + 1
end

coins.keypressed = function(key)
  if key == 'return' then
    if upgrade_marked == table.getn(upgrades) then
      current_state = game_over_state
    elseif number_coins >= upgrades[upgrade_marked].cost then
      number_coins = number_coins - upgrades[upgrade_marked].cost
      if upgrades[upgrade_marked].header == 'Kleeblatt' then
        kleeblatt = kleeblatt + 1
      elseif upgrades[upgrade_marked].header == 'Nuss' then
        nuss = nuss + 3
      end
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
