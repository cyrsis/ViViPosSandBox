[&INIT]
{if duplicate}
[&DWON]${'Bill Copy'|center:16}[&DWOFF]
{/if}
${store.name|center:31}[&CR]
${store.branch|left:15}${store.telephone1|right:16}[&CR]
${(new Date()).toLocaleFormat('%Y-%m-%d %H:%M:%S')|center:31}[&CR]
${'機器編號:'|left:9}${order.terminal_no|left:22}[&CR]
${'收銀員:'|left:7}${order.proceeds_clerk_displayname|left:24}[&CR]
-------------------------------[&CR]
{for item in order.items_summary}
${item.qty_subtotal + 'X'|left:4}${item.name|left:20}${item.subtotal|viviFormatPrices:true|right:7}[&CR]
{/for}
-------------------------------[&CR]
{eval}
percentDiscount = 0;
amountDiscount = 0;
paymentByTypes = {};

var orderItemObj = order.items;
if ( orderItemObj ) {
    for ( var oi in orderItemObj ) {
        var item = orderItemObj[ oi ];
        if ( item.discount_type == '%' )
            percentDiscount += item.current_discount;
        else if ( item.discount_type == '$' )
            amountDiscount += item.current_discount;
    }
}

var orderDiscountObj = order.trans_discounts;
if ( orderDiscountObj ) {
    for ( var od in orderDiscountObj ) {
        var discount = orderDiscountObj[ od ];
        if ( discount.discount_type == '%' )
            percentDiscount += discount.current_discount;
        else if ( discount.discount_type == '$' )
            amountDiscount += discount.current_discount;
    }
}

var orderPaymentObj = order.trans_payments;
if ( orderPaymentObj ) {
    for ( var op in orderPaymentObj ) {
        var payment = orderPaymentObj[ op ];
        if ( payment.name == "coupon" ) {
            if ( !paymentByTypes[ payment.memo1 ] ) {
                paymentByTypes[ payment.memo1 ] = {
                    name: payment.name,
                    memo1: payment.memo1,
                    amount: payment.amount,
                    qty: 1
                };
            } else {
                paymentByTypes[ payment.memo1 ].qty++;
                paymentByTypes[ payment.memo1 ].amount += payment.amount;
            }
        } else {
            paymentByTypes[ payment.id ] = payment;
        }
    }
}
{/eval}
{if percentDiscount != 0}${'折扣:'|left:5}${percentDiscount|viviFormatPrices:true|right:26}[&CR]
{/if}
{if amountDiscount != 0}${'折讓:'|left:5}${amountDiscount|viviFormatPrices:true|right:26}[&CR]
{/if}
{if order.promotion_subtotal != 0}${'促銷金額:'|left:9}${order.promotion_subtotal|viviFormatPrices:true|right:22}[&CR]
{/if}
${'金額總計:'|left:9}${order.total|viviFormatPrices:true|right:22}[&CR]
{for opo in paymentByTypes}
{if opo.name == "coupon"}
${opo.memo1 + ':'|left: 10}${opo.qty + 'X'|left:3}${opo.amount|viviFormatPrices:true|right:18}[&CR]
{elseif opo.name == "cash"}
${'現金' + ':'|left: 5}${opo.amount|viviFormatPrices:true|right:26}[&CR]
{else}
${_( opo.name ) + ':'|left: 10}${opo.amount|viviFormatPrices:true|right:21}[&CR]
{/if}
{/for}
${'已收金額:'|left:9}${order.payment_subtotal|viviFormatPrices:true|right:22}[&CR]
{if order.remain > 0}
${'應收金額:'|left:9}${order.remain|viviFormatPrices:true|right:22}[&CR]
{else}
${'找零:'|left:5}${(0 - order.remain)|viviFormatPrices:true|right:26}[&CR]
{/if}
[&CR]
[&CR]
[&CR]
[&CR]
