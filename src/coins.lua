local coins = {}

local kleeblatt_img
local items = {}
local item_marked


coins.load = function()
  kleeblatt_img = love.graphics.newImage('assets/img/kleeblatt_dummy.png')
  nut_img = love.graphics.newImage('assets/img/nuss_dummy.png')
  table.insert(items, {
    typ = 'upgrade',
    img = kleeblatt_img,
    header = 'Kleeblatt',
    getFunction = savegame.get_cloverleaf,
    cost = 20,
    text = 'Das Kleeblatt erhöht dein Glück!\n(Äste tauchen häufiger auf derselben Seite auf)'
  })
  table.insert(items, {
    typ = 'upgrade',
    img = nut_img,
    header = 'Nuss',
    getFunction = savegame.get_nuts,
    cost = 10,
    text = 'Die Nuss lockt Eichhörnchen an, die zusätzliche Punkte geben!\nJede Nuss lockt 3 Eichhörnchen an.\nUm ein Eichhörnchen zu töten, drücke Space.'
  })
  table.insert(items, {
    typ = 'function',
    header = 'back'
  })
  item_marked = 1
end

coins.draw = function()
  love.graphics.setColor(0, 0, 0)
  love.graphics.setFont(semiLargeFont)
  love.graphics.print('Coins: ' .. savegame.getCoins(persisted_state), 20, 10)
  love.graphics.setFont(normalFont)
  for index, item in ipairs(items) do
    if item.typ == 'upgrade' then
      love.graphics.setColor(255, 255, 255)
      love.graphics.draw(item.img, 20, index*125-70)
    end
    love.graphics.setColor(0, 0, 0)
    if(item_marked == index) then
      love.graphics.setFont(semiLargeFont)
      love.graphics.print(item.header, 140, index*125-40)
    else
      love.graphics.print(item.header, 140, index*125-30)
    end
    love.graphics.setFont(normalFont)
    if item.typ == 'upgrade' then
      love.graphics.print('Du hast ' .. item.getFunction(persisted_state), 140, index*125-10)
      love.graphics.print(item.cost .. ' Coins', 260, index*125-30)
      love.graphics.print(item.text, 330, index*125-40)
    end
  end
end

coins.keypressed = function(key)
  if key == 'return' then
    if item_marked == table.getn(items) then
      current_state = game_over_state
    elseif savegame.getCoins(persisted_state) >= items[item_marked].cost then
      savegame.add_coins(persisted_state, -items[item_marked].cost)
      if items[item_marked].header == 'Kleeblatt' then
        savegame.add_cloverleaf(persisted_state)
      elseif items[item_marked].header == 'Nuss' then
        savegame.add_nuts(persisted_state)
      end
      savegame.save(persisted_state)
    end
  elseif key == 'down' then
    if item_marked < table.getn(items) then
      item_marked = item_marked + 1
    elseif item_marked == table.getn(items) then
      item_marked = 1
    end
  elseif key == 'up' then
    if item_marked > 1 then
      item_marked = item_marked - 1
    elseif item_marked == 1 then
      item_marked = table.getn(items)
    end
  end
end

return coins
