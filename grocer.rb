def consolidate_cart(cart)

  consolidated = {}

  cart.each do |item|
    name = item.keys[0]
    if consolidated[name]
      consolidated[name][:count] += 1
    else 
      consolidated[name] = item[name]
      consolidated[name][:count] = 1
    end
  end

  consolidated

end



def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    coupon_item, num_for_discount, discounted_cost = coupon.values
    
    if cart[coupon_item]
      cart_item, clearance, num_in_cart = cart[coupon_item].values

      if num_in_cart >= num_for_discount
        item_with_coupon = "#{coupon_item} W/COUPON"
        price_for_one = discounted_cost/num_for_discount

        if cart[item_with_coupon]
          cart[item_with_coupon][:count] += num_for_discount
        else 
          cart[item_with_coupon] = {
            price: price_for_one,
            clearance: clearance,
            count: num_for_discount
          }
        end

        cart[coupon_item][:count] = num_in_cart - num_for_discount
      end
    end
  end

  cart
end



def apply_clearance(cart)
  cart.each do |item, info|
    if info[:clearance]
      info[:price] = (info[:price] * 0.8).round(2)
    end
  end
  cart
end



def checkout(cart, coupons)
  consolidated = consolidate_cart(cart)
  with_coupons = apply_coupons(consolidated, coupons)
  final_cart = apply_clearance(with_coupons)

  total = 0

  final_cart.each do |item, info|
    total = total + (info[:price] * info[:count])
  end

  return (total > 100 ? (total * 0.9) : total)
end