{if order.total > 0}
{if order.split_payments}
{eval}
splitPayments=[];
for (tp in order.trans_payments) {
   splitPayments.push( order.trans_payments[tp].amount);
}
{/eval}
{else}
{eval}
splitPayments=[order.payment_subtotal];
{/eval}
{/if}
{for receivePayment in splitPayments}
{eval}
  itemCount = 0;
  pageCount = 0;
  pageSize = 600;
//  marker = GeckoJS.Session.get('uniform_invoice_marker_record');
  marker = GeckoJS.Session.get('uniform_invoice_marker');
  // numPages = Math.ceil(order.items_count / pageSize);
  numPages = 1;
  curPage = 1;
  order.receiptPages = numPages;
  customer_ubn = '';
  if (typeof customer != 'undefined' && customer != null && customer.uniform_business_number != null) {
    customer_ubn = customer.uniform_business_number;
  }
  store_ubn = '';
  if (typeof store != 'undefined' && store != null && store.uniform_business_number != null) {
    store_ubn = store.uniform_business_number;
  }
  tp_list = {};

  for (key in order.items) {
    tp = order.items[key];

    altName2 = tp.alt_name2 || '02';

    if ((altName2) && (altName2 > 0)) {
      if (tp_list[altName2]) {
        tp_list[altName2].subtotal = tp_list[altName2].subtotal + tp.current_subtotal;
      } else {
        tp_list[altName2] = {name: altName2, subtotal:tp.current_subtotal};
      }
    }
  }
//GREUtils.log("********************\n" + GeckoJS.BaseObject.dump(order.items_tax_details));
  tt0 = {tax:0, taxable:0, tax_name: '營業稅'};
  tt12 = {tax:0, taxable:0, tax_name: '娛樂稅'};
  
  tax0 = 0;
  tax1 = 0;
  tax2 = 0;
  tax12 = 0;
  
  for (key in order.items_tax_details) {
    tax = order.items_tax_details[key];    
    if (tax.tax.no == 'T0') {
      tt0.tax = tax.included_tax_subtotal;
      tt0.taxable = tax.taxable_amount;
      
      tax0 = tax.included_tax_subtotal;
    }
    
    if ((tax.tax.no == 'T1') || (tax.tax.no == 'T2')) {
      tt12.tax += tax.included_tax_subtotal;
      tt12.taxable += tax.taxable_amount;
    }
    
    if (tax.tax.no == 'T1') {
      tax1 = tax.included_tax_subtotal;
    }
    if (tax.tax.no == 'T2') {
      tax2 = tax.included_tax_subtotal;
    }
  }
  
  tax12 = Math.round(tax1 + tax2);
  tax012 = Math.round(tax0) + tax12;
  taxable_amount = order.total - tax012;
  
  tt0.tax = tax0;
  tt12.tax = tax12;
  
  order.taxableAmount = taxable_amount;

{/eval}
{eval}
    storefirstline = _MODIFIERS['substr'](store.name, 0, 36);
    storesecondline = store.name.substr(storefirstline.length) || '';
{/eval}
${storefirstline|left:36}
{if storesecondline != ''}
${storesecondline|left:36}
{/if}
No: ${store_ubn|left:10} 電話:${store.telephone1|left:12}
{eval}
    addfirstline = _MODIFIERS['substr'](store.address1, 0, 30);
    addsecondline = store.address1.substr(addfirstline.length) || '';
{/eval}
地址: ${addfirstline|left:30}
{if addsecondline != ''}
      ${addsecondline|left:30}
{/if}
分店: ${store.branch|left:12}  機號: ${order.terminal_no|left:8}
日期: ${(new Date()).toLocaleFormat('%Y-%m-%d %H:%M')}   
營業日:${order.seq|left:16}
{if customer_ubn != ''}
統一編號:${store_ubn|left:8}
{/if}
發票號碼:${marker}
買受人統編:${customer_ubn|left:8}
------------------------------------
{for tp in tp_list}
{if store.city != ''}
${store.city|left:20}${tp.subtotal|viviFormatPrices:true|right:9}
{else}
餐飲費用:    ${tp.subtotal|viviFormatPrices:true|right:16}
{/if}
{/for}
------------------------------------
合計:        ${txn.formatPrice(order.item_subtotal)|right:16}
應收:        ${txn.formatPrice(order.total)|right:16}
{if order.item_discount_subtotal != 0}折扣 :         ${txn.formatPrice(order.item_discount_subtotal)|right:14}
{/if}
{if order.trans_discount_subtotal != 0}全單折扣:       ${txn.formatPrice(order.trans_discount_subtotal)|right:10}
{/if}
{if order.trans_surcharge_subtotal != 0}加價:           ${txn.formatPrice(order.trans_surcharge_subtotal)|right:14}
{/if}
付款:        ${txn.formatPrice(order.payment_subtotal)|right:16}
找零:        ${txn.formatPrice(0 - order.remain)|right:16}
------------------------------------
總金額:      ${taxable_amount|viviFormatPrices:true|right:16}

發票有誤請於七日內更換,逾時恕不受理
[&FF]
{/for}
{/if}
