{if order.destination_prefix == 2111 || order.destination_prefix == 2112 || order.destination_prefix == 2121 || order.destination_prefix == 2122 || order.destination_prefix == 2211 || order.destination_prefix == 2212 || order.destination_prefix == 2221 || order.destination_prefix == 2222}
{if hasLinkedItems}
[&INIT]
{eval}
  if (order.check_no == null || order.check_no == '') {
    check_no = '';
  }
  else {
    check_no = (order.check_no || '').toString();
    check_no = GeckoJS.String.padLeft(check_no.substring(-3), 3, '0');
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
{/eval}
{eval}
  now = new Date();
  today = now.toLocaleFormat('%Y/%m/%d');
  time = now.toLocaleFormat('%H:%M');
  terminal = order.terminal_no;
  qty_subtotal = order.qty_subtotal;
  index = 0;
  count = 0;
  total = 0;
  memos = [];
  newItems = {};
  for (itemKey in order.display_sequences) {
    item = order.display_sequences[itemKey]
    conds = '';
    memo = '';
    if ((item.type == 'item' || item.type == 'setitem') && order.items[item.index] != null && order.items[item.index].linked) {
      for (condKey in order.items[item.index].collapsedCondiments) {
        conds = condKey;
      }
      memo = order.items[item.index].memo;
    
      key = order.items[item.index].no + conds + memo;
      if (newItems[key] && (newItems[key].conds == conds) && (newItems[key].memo == memo)) {
        newItems[key].current_qty += order.items[item.index].current_qty;
      } else {
        newItems[key] = GREUtils.extend({}, order.items[item.index]);
        newItems[key].conds = conds;
      }
      total += order.items[item.index].current_qty;
    } else if (order.items[item.index] == null) {
      newItems[item.index] = GREUtils.extend({}, item);
    }
  }
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
    else if (payment.name == 'giftcard') display_name = '禮券';
    else if (payment.name == 'coupon') display_name = '折價券';
    else if (payment.name == 'check') display_name = '支票';
    else if (payment.name == 'cash') display_name = '現金';

    payment_types.push({
      name: payment.name,
      memo1: payment.memo1,
      display_name: display_name,
      amount: payment.amount
    });

    payment_types_str += display_name + ',';
  }
{/eval}
[&QSON]${store.branch|center:16}[&QSOFF]

[&QSON]${order.destination}單號:${sequence|tail:3}[&QSOFF]
{if order.check_no != ''}
[&QSON]取餐牌號: ${order.check_no}[&QSOFF]
{/if}
{if order.table_name != 0}
[&QSON]桌名:${table_name|left:10}[&QSOFF]
{/if}
日期:${today|left:12}時間:${time}
交易序號: ${order.seq|left:13}   *0101A
--------------------------------
${'商品名稱'|left:20}${'數量'|left:6}${'價格'|right:6}
--------------------------------
{for item in newItems}
{if item.type == 'item' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
    if (item.conds) {
      itemName = item.name + '●' + item.conds ;
    } else {
      itemName = item.name;
    }
    if (item.memo) {
      itemName += '<' + item.memo + '>';
    }
    firstline = _MODIFIERS['substr'](itemName, 0, 18);
    secondline = itemName.substr(firstline.length) || '';
{/eval}
[&DHON]${firstline|left:20}${item.current_qty|right:3}${item.current_subtotal|right:8}[&DHOFF]
{if secondline != ''}
     ....${secondline|left:20}
{/if}
{elseif item.type == 'setitem' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
    if (item.conds) {
      itemName = item.name + '(' + item.conds + ')';
    } else {
      itemName = item.name;
    }
    firstline = _MODIFIERS['substr'](itemName, 0, 16);
    secondline = itemName.substr(firstline.length) || '';
{/eval}
     [&DHON]◎${firstline|left:16}${order.items[item.index].current_qty|right:3}${item.current_subtotal|right:7}[&DHOFF]
{if secondline != ''}
     ...[&DHON]${secondline|left:20}[&DHOFF]
{/if}
{elseif item.type == 'memo' && (item.index == null || order.items[item.index] == null || order.items[item.index].linked)}
{/if}
{/for}
--------------------------------
{if order.item_subtotal != order.total}
原始總金額：         ${order.item_subtotal|right:10}
{if order.discount_subtotal != 0}
折扣總金額：         ${order.discount_subtotal|right:10}
{/if}
{if order.surcharge_subtotal != 0}
服務費金額：         ${order.surcharge_subtotal|right:10}
{/if}
{if order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal > 0}
促銷總金額：         ${-(order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal)|right:10}
{/if}
--------------------------------
{/if}
[&DHON]${'總計:'|left:20}${count|right:3}${order.total|right:6}元[&DHOFF]
{if memos.length > 0}
{for memo in memos}
--------------------------------
[&DHON]訂單備註：${memo|left:36}[&DHOFF]
{/for}
{/if}
{if customer != null}
--------------------------------
名稱: ${customer.name|left:26}
      ${customer.customer_id|left:26}
電話: ${customer.telephone|left:26}
地址: ${customer.addr1_addr1|left:26}
{if customer.addr1_addr2 != null && customer.addr1_addr2 != ''}
    : ${customer.addr1_addr2|left:26}
{/if}
{/if}
{if store.country != ''}
[&CR]
${store.country|center:32}
{/if}
[&CR]
[&CR]
[&CR]
[&PC]
[&OPENDRAWER]
{/if}
{/if}