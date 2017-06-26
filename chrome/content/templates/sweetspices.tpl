{eval}
  sequence = order.seq.toString();
  if (sequence == null) {
    sequence = '';
  }
  else {
    sequence = sequence.substr(-2);
  }
  count = 0;
  total = 0;
{/eval}
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
[&INIT]

[&QSON]${store.name|center:20}[&QSOFF]
${store.address1|center:40}
${store.address2|center:40}
{if duplicate}
[&QSON]${'Receipt Copy'|center:20}[&QSOFF]
{/if}
[&CR]
${'INVOICE #  :'}${order.seq}
${'TIME : '|left:12}${(new Date()).toLocaleFormat('%Y-%m-%d')|left:15}${(new Date()).toLocaleFormat('%H:%M:%S')}
${'User  :'|left:12}${order.proceeds_clerk_displayname}

QTY   ITEM                UNIT      PRICE
-----------------------------------------
{for item in order.display_sequences}
{if item.type == 'item'}
${item.current_qty|left:4} ${item.name|left:20} @${item.current_price} ${item.current_subtotal|right:9}
{elseif item.type == 'condiment'}
    {if item.current_price != null && item.current_price != 0}
    ${item.alt_language|left:12} @${item.current_price|right:6}
    {else}
    ${item.alt_language|left:36}
    {/if}
{elseif item.type == 'setitem'}
    {if item.current_price != null && item.current_price != 0}
    ${item.name|left:12} @${item.current_price|right:6}
    {else}
    ${item.name|left:36}
    {/if}
{elseif item.type == 'memo'}
        ${item.alt_name1|left:32}
{elseif item.type == 'discount' || item.type == 'surcharge'}
     ${item.name|left:20} ${item.current_subtotal|right:13}
{elseif item.type == 'tray'}
     ${item.alt_name1|left:20} ${item.current_subtotal|right:12}
{/if}
{/for}
__________________________________________
${'Subtotal:'|left:15}${(order.total)|viviFormatPrices:true|right:24}
[&CR]
${'Payment:'|left:15}
{for payment in order.trans_payments}
{eval}
{/eval}
{if payment.name == 'cash'}
  ${'Cash:'|left:15} ${payment.amount|viviFormatPrices:true|right:22}
{else}
   ${payment.memo1 + ':'|left:15} ${payment.amount|viviFormatPrices:true|right:22}
{/if}
{/for}
[&CR]
{if order.trans_discount_subtotal != 0 || order.trans_surcharge_subtotal != 0 || order.revalue_subtotal != 0 || order.promotion_subtotal != 0}
{if order.trans_discount_subtotal != 0}${'Discount:'|left:15} ${order.trans_discount_subtotal|viviFormatPrices:true|right:24}
{/if}
{if order.trans_surcharge_subtotal != 0}${'Service Charge:'|left:15} ${order.trans_surcharge_subtotal|viviFormatPrices:true|right:24}
{/if}
{if order.revalue_subtotal != 0}${'Order Revalue:'|left:15} ${order.revalue_subtotal|viviFormatPrices:true|right:24}
{/if}
{if order.promotion_subtotal != 0}${'Promotion:'|left:15} ${order.promotion_subtotal|viviFormatPrices:true|right:24}
{/if}
{/if}

[&QSON]${'TOTAL:'|left:16} ${order.total|viviFormatPrices:true}[&QSOFF]

${'Recieved:'|left:15} ${receivePayment|viviFormatPrices:true|right:24}
${'Changes:'|left:15} ${order.remain|viviFormatPrices:true|right:24}
----------------------------------------
{if  customer != null}
Name: ${customer.name|left:36}
Phone Number: ${customer.telephone|left:36}
Address: ${customer.addr1_addr1|left:36}
{if customer.addr1_addr2 != null && customer.addr1_addr2 != ''}
    : ${customer.addr1_addr2|left:36}
{/if}
{if customer.addr1_city != null && customer.addr1_city != ''}
    : ${customer.addr1_city|left:36}
{/if}
------------------------------------------
{/if}
[&LF]
${'Phone:' + store.telephone1|center:40}
${'Please come again to Sweet Spice!!'|center:40}
[&LF]
[&LF]
[&LF]
{/for}
[&PC]
[&LF]
[&LF]