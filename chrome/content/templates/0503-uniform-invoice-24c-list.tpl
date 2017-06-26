{if order.total > 0}
{eval}
  itemCount = 0;
  pageCount = 0;
  pageSize = 7;
  numPages = Math.ceil(order.items_count / pageSize);
  curPage = 1;
  order.receiptPages = numPages;
  customer_ubn = null;
  if (typeof customer != 'undefined' && customer != null && customer.uniform_business_number != null) {
    customer_ubn = customer.uniform_business_number;
  }
  store_ubn = null;
  if (typeof store != 'undefined' && store != null && store.uniform_business_number != null) {
    store_ubn = store.uniform_business_number;
  }
    
  new_total = order.total - order.trans_discount_subtotal - order.trans_surcharge_subtotal;
  payment_types = [];
  payment_types_str = '';
  for (key in order.trans_payments) {
    payment = order.trans_payments[key];
    if (payment.name == 'creditcard') display_name = '信用卡';
    else if (payment.name == 'giftcard') display_name = '禮券';
    else if (payment.name == 'coupon') display_name = '折價券';
    else if (payment.name == 'check') display_name = '支票';
    else display_name = '現金';

    payment_types.push({
      name: payment.name,
      memo1: payment.memo1,
      display_name: display_name,
      amount: payment.amount
    });

    payment_types_str += display_name + ',';
	  }
{/eval}
{for item in order.items}
{if item.parent_index == null || item.parent_index == ''}
{if pageCount == 0}
{eval}
    storefirstline = _MODIFIERS['substr'](store.name, 0, 24);
    storesecondline = store.name.substr(storefirstline.length) || '';
{/eval}
${storefirstline|center:24}
{if storesecondline != ''}
${storesecondline|center:24}
{/if}
{eval}
    addfirstline = _MODIFIERS['substr'](store.address1, 0, 24);
    addsecondline = store.address1.substr(addfirstline.length) || '';
{/eval}
${addfirstline|center:24}
{if addsecondline != ''}
${addsecondline|center:24}
{/if}
   Tel:${store.telephone1|center:12}
{if store_ubn != null}
      No:${store_ubn|center:8}
{/if}
店:${store.branch|left:21} 
收銀:${order.proceeds_clerk|left:13} ${curPage+'/'+numPages|right:3}頁
${'日:'|left:3}${(new Date()).toLocaleFormat('%Y-%m-%d')} 時:${(new Date()).toLocaleFormat('%H:%M')}
序:${order.seq|right:11} 機:${order.terminal_no|left:6}
{if customer_ubn != null}
統一編號:${customer_ubn|left:8}
{/if}
{/if}
{if item.current_qty > 1}
${item.name|left:24}
    ${txn.formatPrice(item.current_price)|right:5} X ${item.current_qty|left:4}${txn.formatPrice(item.current_subtotal)|right:5}${item.tax_name|right:3}
{else}
${item.name|left:16}${txn.formatPrice(item.current_subtotal)|right:5}${item.tax_name|right:3}
{/if}
{if item.hasDiscount}${item.discount_name|right:12}    ${txn.formatPrice(item.current_discount)|right:5}${item.tax_name|right:3}
{/if}
{if item.hasSurcharge}${item.surcharge_name|right:12}   ${'+' + txn.formatPrice(item.current_surcharge)|right:6}${item.tax_name|right:3}
{/if}
{eval}
pageCount++;
itemCount++;
{/eval}
{if pageCount == pageSize || itemCount == order.items_count}
{if curPage == numPages}
${order.items_count + '項'|left:4}總計:   ${txn.formatPrice(order.item_subtotal)|right:12}
{if order.discount_subtotal != 0}
總折扣: ${txn.formatPrice(order.discount_subtotal)|right:16}
{/if}
{if order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal > 0}
促銷:   ${-(order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal)|right:16}
{/if}
{if order.surcharge_subtotal != 0}
服務費: ${txn.formatPrice(order.surcharge_subtotal)|right:16}
{/if}
結帳金額: ${order.total|right:14}
{for payment_type in payment_types}
${'**' + payment_type.display_name + '付款:'|left:16}${payment_type.amount|viviFormatPrices:true|right:8}
{/for}
{if 0 - order.remain > 0}
找零:   ${txn.formatPrice(0 - order.remain)|right:16}
{/if}
{/if}
[&FF]
{eval}
  curPage++;
  pageCount = 0;
{/eval}
{/if}
{/if}
{/for}
{/if}
