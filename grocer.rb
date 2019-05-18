def consolidate_cart(cart)
  new_hash = {}
  cart.each do |item|
    item_key = item.keys.first
    if new_hash.keys.include?(item_key)
      new_hash[item_key][:count] += 1
    else
      new_hash[item_key] = item[item_key]
      new_hash[item_key][:count] = 1
    end
  end
  return new_hash
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon[:item]
    cart.clone.each do |key, data|
      if key == item
        if data[:count] >= coupon[:num]
          cart[item + " W/COUPON"] = {price: coupon[:cost], clearance: data[:clearance], count: data[:count]/coupon[:num]}
          cart[item][:count] = data[:count] % coupon[:num]
        end
      end
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.map do |item, data|
    if data[:clearance] == true
      data[:price] = (data[:price] * 0.8).round(2)
    end
  end
  return cart
end

def checkout(cart, coupons)
  consolidated = consolidate_cart(cart)
  after_coupons = apply_coupons(consolidated, coupons)
  after_clearance = apply_clearance(after_coupons)
  total = 0
  after_clearance.each_value do |value|
    price = value[:price] * value[:count]
    total += price
  end
  if total > 100
    total = (total * 0.9).round(2)
  end
  return total
end
