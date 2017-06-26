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
  table_name = order.table_no || '';
  tablesByNo = GeckoJS.Session.get('tablesByNo');
  if (tablesByNo) {
    table = tablesByNo[order.table_no];
    if (table) {
      table_name = table.table_name;
    }
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
{if order.destination == '堂食'}
[&QSON]堂食       ${'單號:'|left:5}${order.check_no|default:''|left:5}[&QSOFF]
{elseif order.destination == '外送'}
[&QSON]外送       ${'單號:'|left:5}${order.check_no|default:''|left:5}[&QSOFF]
{elseif order.destination == '自取'}
[&QSON]自取       ${'單號:'|left:5}${order.check_no|default:''|left:5}[&QSOFF]
{elseif order.destination == '夜堂'}
[&QSON]夜堂       ${'單號:'|left:5}${order.check_no|default:''|left:5}[&QSOFF]
{/if}
{if order.table_name != ''}
[&QSON]${'桌:' + table_name + '   ' + '客數:' + order.no_of_customers|left:21}[&QSOFF]
{else}
[&QSON]${'【' + order.destination + '】  ' + sequence|tail:2 + '號'|left:21}[&QSOFF]
{/if}
[&CR]
${'單號:'|left:6}${order.seq|left:13} ${'點餐人員:'|left:10}${order.service_clerk_displayname|left:12}
___________________________________
{for item in order.display_sequences}
{if item.type == 'item' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
    firstline = _MODIFIERS['substr'](item.name, 0, 32);
    secondline = item.name.substr(firstline.length) || '';
{/eval}
{if order.items[item.index].current_qty > 0}
[&QSON]${'x'+order.items[item.index].current_qty} ${firstline|left:16}[&QSOFF][&DHON][&DHOFF]
{if secondline != ''}
[&DHON]${secondline|left:16}[&DHOFF]
{/if}
{else}
[&QSON]
[0x1B][0x72][0x01]
取消
[0x1B][0x72][0x00]
[&QSOFF]
[&QSON]${firstline|left:16}[&QSOFF][&DHON]${Math.abs(order.items[item.index].current_qty)|right:5}[&DHOFF]
{if secondline != ''}
[&DHON]   ${secondline|left:16}[&DHOFF]
{/if}
{/if}
{elseif item.type == 'setitem' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
    firstline = _MODIFIERS['substr'](item.name, 0, 31);
    secondline = item.name.substr(firstline.length) || '';
{/eval}
   [&QSON]→${order.items[item.index].current_qty} x ${firstline}[&QSOFF][&DHON] [&DHOFF]
{if secondline != ''}
   ...[&QSON]${secondline|left:14}[&QSOFF]
{/if}
{elseif item.type == 'condiment' && (item.index == null || order.items[item.index].linked)}
{eval}
  if (order.items[item.index].parent_index) {
    condimentName = '>>' + item.name + ' X '+order.items[item.index].current_qty ;
    firstline = _MODIFIERS['substr'](condimentName, 0, 30);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '  ' + secondline;
  }
  else {
    condimentName = '>>' + item.name + ' X '+order.items[item.index].current_qty;
    firstline = _MODIFIERS['substr'](condimentName, 0, 30);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '  ' + secondline;
  }
{/eval}
    [&DHON]${firstline|left:30}[&DHOFF]
{if secondline != ''}
    [&DHON]${secondline|left:30}[&DHOFF]
{/if}
{elseif item.type == 'memo' && (item.index == null || order.items[item.index] == null || order.items[item.index].linked)}
{if item.index == null || order.items[item.index] == null}
___________________________________
[&DHON]訂單備註：${item.name}[&DHOFF]
{else}
[&QSON]${item.name}[&QSOFF]
{/if}
{/if}
{/for}
___________________________________
${'列印時間:'|left:10}${(new Date()).toLocaleFormat('%Y-%m-%d %H:%M:%S')}
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
[&CR]
{/if}