{if order.destination_prefix == 2111 || order.destination_prefix == 2112 || order.destination_prefix == 2121 || order.destination_prefix == 2122 || order.destination_prefix == 2211 || order.destination_prefix == 2212 || order.destination_prefix == 2221 || order.destination_prefix == 2222}
{eval}
  clerk = order.proceeds_clerk_displayname;
  if (clerk == null || clerk == '') {
    clerk = order.service_clerk_displayname;
  }
  if (clerk == null) {
    clerk = '';
  }
  var sequenceTracksDate = GeckoJS.Configure.read('vivipos.fec.settings.SequenceTracksSalePeriod');
  var sequenceLength = GeckoJS.Configure.read('vivipos.fec.settings.SequenceNumberLength');
  sequence = order.seq.toString();
  if (sequence == null) {
    sequence = '';
  }
  else if (sequenceTracksDate) {
    sequence = sequence.substr(-sequenceLength);
  }
  now = new Date();
  today = now.toLocaleFormat('%Y/%m/%d');
  time = now.toLocaleFormat('%H:%M');
  terminal = order.terminal_no;
  index = 0;
  count = 0;
  memos = [];
{/eval}
{eval}
  table_name = order.table_no || '';
  tablesByNo = GeckoJS.Session.get('tablesByNo');
  if (tablesByNo) {
    table = tablesByNo[order.table_no];
    if (table) {
      table_name = table.table_name;
    }
  }
  payment_types = [];
  payment_types_str = '';
  for (key in order.trans_payments) {
    payment = order.trans_payments[key];
    if (payment.name == 'creditcard') display_name = '信用卡';
    else if (payment.name == 'giftcard') display_name = '礼券';
    else if (payment.name == 'coupon') display_name = '折価券';
    else if (payment.name == 'check') display_name = '支票';
    else display_name = '现金';

    payment_types.push({
      name: payment.name,
      memo1: payment.memo1,
      display_name: display_name,
      amount: payment.amount
    });

    payment_types_str += display_name + ',';
  }
{/eval}
[&INIT]
[&QSON]${order.destination}单号:${sequence|tail:3}[&QSOFF]
{if order.check_no != ''}
[&QSON]取餐号码:${order.check_no}[&QSOFF]
{/if}
{if order.table_name != 0}
[&QSON]桌名:${table_name|left:16}[&QSOFF]
{/if}
日期:${today|left:24}时间:${time}
交易序号: ${order.seq|left:26}
----------------------------------------------
${'商品名称'|left:28} ${'数量'|left:6} ${'金额'|right:8}
----------------------------------------------
{for item in order.display_sequences}
{if item.type == 'item'}
{eval}
  condStr = '';
  itemTrans = order.items[item.index];
  condiments = itemTrans.condiments;
  count += parseInt(itemTrans.current_qty);
  if (condiments != null) {
    condStr = GeckoJS.BaseObject.getKeys(condiments).join(';');
  }
{/eval}
[&DHON]${itemTrans.name|left:27}${itemTrans.current_qty|right:6}${item.current_subtotal|right:11}[&DHOFF]
{elseif item.type == 'discount' || item.type == 'surcharge'}
  ◎${item.name|left:30}${item.current_subtotal|right:10}
{elseif item.type == 'setitem'}
[&DHON]${'→'}${order.items[item.index].name|left:26}[&DHOFF]${item.current_qty|right:6}
{elseif item.type == 'condiment'}
{eval}
  if (order.items[item.index].parent_index) {
    condimentName = '●' + item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 28);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '  ' + secondline;
  }
  else {
    condimentName = '●' + item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 28);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '  ' + secondline;
  }
{/eval}
{if store.county != ''}
  [&DHON]${firstline|left:30}[&DHOFF]
{if secondline != ''}
  [&DHON]${secondline|left:30}[&DHOFF]
{/if}
{elseif}
  ${firstline|left:30}
{if secondline != ''}
  ${secondline|left:30}
{/if}
{/if}
{elseif item.type == 'memo'}
{eval}
  memoStr = '';
  itemTrans = order.items[item.index];
  if (itemTrans == null) {
      memos.push(item.name);
  }
  else {
    memoStr = item.name;
  }
{/eval}
{if memoStr != ''}
    ${memoStr|left:38}
{/if}
{/if}
{/for}
----------------------------------------------
店名: ${store.branch|left:22} *总计: ${order.total|right:8}
服务电话: ${store.telephone1|left:18} *付款: ${payment.amount|viviFormatPrices:true|right:8}
邮编: ${store.zip|left:22} *找零: {if (0 - order.remain) > 0}${(0 - order.remain)|right:8}{/if}[&CR]
联络人: ${store.contact}
地址: ${store.address1}
{if memos.length > 0}
{for memo in memos}
----------------------------------------------
[&DHON]订单备注：${memo|left:36}[&DHOFF]
{/for}
{/if}
{if customer != null}
----------------------------------------------
          名称: ${customer.name}
          电话: ${customer.telephone}
          地址: ${customer.addr1_addr1}
{if customer.addr1_addr2 != null && customer.addr1_addr2 != ''}
              : ${customer.addr1_addr2|left:36}
{/if}
{if customer.addr1_city != null && customer.addr1_city != ''}
    : ${customer.addr1_city|left:36}
{/if}
{/if}
{if store.country != ''}
${store.country|center:32}
{/if}
[&CR]
[&CR]
[&CR]
[&OPENDRAWER]
[&PC]
{/if}