{eval}
  Invoice_Name = GeckoJS.Configure.read("vivipos.fec.settings.uniform.invoice.Representative.Item.Name")||'';
{/eval}
{if Invoice_Name != ''}
{eval}
  itemCount = 0;
  pageCount = 0;
  pageSize = 300;
  numPages = Math.ceil(order.items_count / pageSize);
  curPage = 1;
  order.receiptPages = numPages;
  promotion_subtotal = order.promotion_subtotal;
  customer_ubn = null;
  storefirstline = _MODIFIERS['substr'](store.name, 0, 24);
  storesecondline = store.name.substr(storefirstline.length) || '';
  addfirstline = _MODIFIERS['substr'](store.address1, 0, 24);
  addsecondline = store.address1.substr(addfirstline.length) || '';
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
${storefirstline|center:24}
{if storesecondline != ''}
${storesecondline|center:24}
{/if}
${addfirstline|center:24}
{if addsecondline != ''}
${addsecondline|center:24}
{/if}
   Tel:${store.telephone1|center:12}
{if store_ubn != null}
      No:${store_ubn|center:8}
{/if}
店:${store.branch|left:10}機:${order.terminal_no|left:7} 
收銀:${order.proceeds_clerk|left:13} ${curPage+'/'+numPages|right:3}頁
${'日期:'|left:4} ${(new Date()).toLocaleFormat('%Y-%m-%d')} 時:${(new Date()).toLocaleFormat('%H:%M')}
序:${order.seq|right:12} 
{if customer_ubn != null}
買受人統編:${customer_ubn|left:8}
{/if}
[&CR]
{eval}
pageCount++;
itemCount++;
{/eval}
${Invoice_Name|left:18}${txn.formatPrice(order.item_subtotal)|right:6}
[&CR]
[&CR]
{if order.surcharge_subtotal != 0}
${'服務費:'|left:12}${txn.formatPrice(order.surcharge_subtotal)|right:12}
{/if}
{if promotion_subtotal != 0}
${'促銷折扣金額:'|left:12}${txn.formatPrice(promotion_subtotal)|right:12}
{/if}
{if order.discount_subtotal != 0}
${'折扣總計:'|left:12}${txn.formatPrice(order.discount_subtotal)|right:12}
{/if}
總計:   [&QSON]${txn.formatPrice(order.total)|right:8}[&QSOFF]
{for payment_type in payment_types}
${payment_type.display_name + ':'|left:8}${payment_type.amount|viviFormatPrices:true|right:16}
{/for}
找零:   ${txn.formatPrice(0 - order.remain)|right:16}
{if order.total <= 0}
- 零及負數發票不得兌獎 -
{/if}
[&FF]
{else}
{eval}
  itemCount = 0;
  pageCount = 0;
  pageSize = 7;
  numPages = Math.ceil(order.items_count / pageSize);
  curPage = 1;
  order.receiptPages = numPages;
  promotion_subtotal = order.promotion_subtotal;
  customer_ubn = null;
  storefirstline = _MODIFIERS['substr'](store.name, 0, 24);
  storesecondline = store.name.substr(storefirstline.length) || '';
  addfirstline = _MODIFIERS['substr'](store.address1, 0, 24);
  addsecondline = store.address1.substr(addfirstline.length) || '';
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
${storefirstline|center:24}
{if storesecondline != ''}
${storesecondline|center:24}
{/if}
${addfirstline|center:24}
{if addsecondline != ''}
${addsecondline|center:24}
{/if}
   Tel:${store.telephone1|center:12}
{if store_ubn != null}
      No:${store_ubn|center:8}
{/if}
店:${store.branch|left:10}機:${order.terminal_no|left:7} 
收銀:${order.proceeds_clerk|left:13} ${curPage+'/'+numPages|right:3}頁
${'日期:'|left:4} ${(new Date()).toLocaleFormat('%Y-%m-%d')} 時:${(new Date()).toLocaleFormat('%H:%M')}
序:${order.seq|right:12} 
{if customer_ubn != null}
買受人統編:${customer_ubn|left:8}
{/if}
{/if}
 ${item.current_qty|left:2}X ${item.name|left:19}
${txn.formatPrice(item.current_subtotal)|right:20} ${item.tax_name|left:3}
{if item.hasDiscount}${item.discount_name|right:8} ${txn.formatPrice(item.current_discount)|right:11}
{/if}
{if item.hasSurcharge}${item.surcharge_name|right:8} ${'+' + txn.formatPrice(item.current_surcharge)|right:11}
{/if}
{eval}
pageCount++;
itemCount++;
{/eval}
{if pageCount == pageSize || itemCount == order.items_count}
{if curPage == numPages}
${order.items_count + '項'|left:4}小計:   ${txn.formatPrice(order.item_subtotal)|right:12}
{if order.surcharge_subtotal != 0}
${'服務費:'|left:12}${txn.formatPrice(order.surcharge_subtotal)|right:12}
{/if}
{if promotion_subtotal != 0}
${'促銷折扣金額:'|left:12}${txn.formatPrice(promotion_subtotal)|right:12}
{/if}
{if order.discount_subtotal != 0}
${'折扣總計:'|left:12}${txn.formatPrice(order.discount_subtotal)|right:12}
{/if}
${order.items_count + '項'|left:4}總計: [&QSON]${txn.formatPrice(order.total)|right:7}[&QSOFF]
{for payment_type in payment_types}
${payment_type.display_name + '付款:'|left:12}${payment_type.amount|viviFormatPrices:true|right:12}
{/for}
找零:   ${txn.formatPrice(0 - order.remain)|right:16}
{/if}
{if order.total <= 0}
- 零及負數發票不得兌獎 -
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