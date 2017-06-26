{if order.destination_prefix == 1211 || order.destination_prefix == 1212 || order.destination_prefix == 1221 || order.destination_prefix == 1222 || order.destination_prefix == 2211 || order.destination_prefix == 2212 || order.destination_prefix == 2221 || order.destination_prefix == 2222}
{if hasLinkedItems}
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
[&INIT]
[&QSON]${store.branch|center:21}[&QSOFF]
[&CR]
{if store.state != ''}
[&QSON]${order.destination}單號:${sequence|tail:2}[&QSOFF]{if order.table_name != ''}  [&QSON]桌名:${table_name}[&QSOFF]{/if}
[&CR]
{else}
[&QSON]${order.destination}單號:${sequence|tail:3}[&QSOFF]{if order.table_name != ''}  [&QSON]桌名:${table_name}[&QSOFF]{/if}
[&CR]
{if order.check_no != ''}
[&QSON]取餐號碼:${order.check_no}[&QSOFF]
{/if}
{/if}
${'單據號碼:'|left:10}${order.seq|left:13} ${'服務人員:'|left:10}${order.service_clerk_displayname|left:8}
------------------------------------------
{for item in order.display_sequences}
{if item.type == 'item' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
    firstline = _MODIFIERS['substr'](item.name, 0, 32);
    secondline = item.name.substr(firstline.length) || '';
	itemTrans = order.items[item.index];
	count += parseInt(itemTrans.current_qty);
{/eval}
[&DHON]${++index|right:2}${'.'}[&DHOFF][&QSON]${firstline|left:16}[&QSOFF][&DHON]x${order.items[item.index].current_qty|right:4}[&DHOFF]
{if secondline != ''}
   ...[&DHON]${secondline|left:14}[&DHOFF]
{/if}
{elseif item.type == 'setitem' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
    firstline = _MODIFIERS['substr'](item.name, 0, 31);
    secondline = item.name.substr(firstline.length) || '';
{/eval}
   [&QSON]→${firstline|left:14}[&QSOFF][&DHON] ${order.items[item.index].current_qty|right:4}[&DHOFF]
{if secondline != ''}
   ...[&QSON]${secondline|left:14}[&QSOFF]
{/if}
{elseif item.type == 'condiment' && (item.index == null || order.items[item.index].linked)}
{eval}
  if (order.items[item.index].parent_index) {
    condimentName = '●' + item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 30);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '  ' + secondline;
  }
  else {
    condimentName = '●' + item.name;
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
------------------------------------------
[&DHON]訂單備註：${item.name}[&DHOFF]
{else}
[&DHON]備註：${item.name}[&DHOFF]
{/if}
{/if}
{/for}
------------------------------------------
[&QSON]${'總計:' + count + '項' + ' ' +order.total + '元'}[&QSOFF]
------------------------------------------
${'列印時間:'|left:10}${(new Date()).toLocaleFormat('%Y-%m-%d %H:%M:%S')}${'*0207C'|right:12}
[&CR]
[&CR]
[&CR]
[&OPENDRAWER]
[&PC]
{/if}
{/if}