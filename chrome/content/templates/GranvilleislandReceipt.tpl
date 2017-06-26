[&INIT]
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
[0x1C][0x70][0x01][0x00]
 [&DWON]${"Granville Island"|center:20}[&DWOFF]
   Ground Floor, No. 25 School Street
            Tai Hang,HK
{if duplicate}
   [&QSON]${'Duplicate Receipt'|center:20}[&QSOFF]
{/if}
${'Invoice #:'}${order.seq}
${'Time: '|left:9}${(new Date()).toLocaleFormat('%Y-%m-%d')|left:15}${(new Date()).toLocaleFormat('%H:%M:%S')}
${'Server:'|left:12}${order.proceeds_clerk_displayname}
${'No. of Person:'|left:17}(${order.no_of_customers})

[&DWON]${'Table:'+order.table_name|center:20}[&DWOFF]

   QT   Item                 Unit.P  Price
------------------------------------------
{for item in order.display_sequences}
{if item.type == 'item'}
${item.current_qty|right:2} ${item.name}
                              ${item.current_price|left:5}   ${item.current_subtotal}
{elseif item.type == 'condiment'}
    {if item.current_price != null && item.current_price != 0}
    ${item.name|left:12} @${item.current_price|right:6}
    {else}
    ${item.name|left:36}
    {/if}
{elseif item.type == 'setitem'}
    {if item.current_price != null && item.current_price != 0}
    ${item.name|left:12} @${item.current_price|right:6}
    {else}
    ${item.name|left:36}
    {/if}
{elseif item.type == 'memo'}
        ${item.name|left:32}
{elseif item.type == 'discount' || item.type == 'surcharge'}
     ${item.name|left:20} ${item.current_subtotal|right:12}
{elseif item.type == 'tray'}
     ${item.name|left:20} ${item.current_subtotal|right:12}
{/if}
{/for}
__________________________________________

${'Payment:'|left:15}
{for payment in order.trans_payments}
{eval}
{/eval}
{if payment.name == 'cash'}
  [&QSON]${'Cash:'|left:15} ${payment.amount|viviFormatPrices:true|left:30}[&QSOFF]
{else}
   ${payment.memo1 + ':'|left:15} ${payment.amount|viviFormatPrices:true|right:22}
{/if}
{/for}
[&CR]
{if order.trans_discount_subtotal != 0 || order.trans_surcharge_subtotal != 0 || order.revalue_subtotal != 0 || order.promotion_subtotal != 0}
{if order.trans_discount_subtotal != 0}${'Discount:'|left:15} ${order.trans_discount_subtotal|viviFormatPrices:true|right:24}
{/if}
{if order.trans_surcharge_subtotal!= 0}${'Service Charge:'|left:15} ${order.trans_surcharge_subtotal|viviFormatPrices:true|right:24}
{/if}
{if order.revalue_subtotal != 0}${'Order Revalue:'|left:15} ${order.revalue_subtotal|viviFormatPrices:true|right:24}
{/if}
{if order.promotion_subtotal != 0}${'Promotion:'|left:15} ${order.promotion_subtotal|viviFormatPrices:true|right:24}
{/if}
{/if}

[&DWON]${'Total:'|left:14} ${order.total|viviFormatPrices:true}[&DWOFF]
${'Service Charge:'|left:15} ${order.tax_subtotal|viviFormatPrices:true|right:24}
${'Recieved:'|left:15} ${receivePayment|viviFormatPrices:true|right:24}
${'Changes:'|left:15} ${order.remain|viviFormatPrices:true|right:24}
----------------------------------------
{if  customer != null}
Customer: ${customer.name|left:36}
Phone: ${customer.telephone|left:36}
Address: ${customer.addr1_addr1|ldeft:36}
{if customer.addr1_addr2 != null && customer.addr1_addr2 != ''}
    : ${customer.addr1_addr2|left:36}
{/if}
{if customer.addr1_city != null && customer.addr1_city != ''}
    : ${customer.addr1_city|left:36}
{/if}
------------------------------------------
{/if}
[&CR]
[&CR]
[&CR]
       Quality ingredients + Passion
             = Welcome Back
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
{/for}