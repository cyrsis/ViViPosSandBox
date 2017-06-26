{if order.destination_prefix == 1211 || order.destination_prefix == 1212 || order.destination_prefix == 1221 || order.destination_prefix == 1222 || order.destination_prefix == 2211 || order.destination_prefix == 2212 || order.destination_prefix == 2221 || order.destination_prefix == 2222}
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
[&QSON]${store.branch|center:21}[&QSOFF]
[&CR]
{if store.state != ''}
[&QSON]${order.destination} No:${order.seq|tail:2}[&QSOFF]{if order.table_name != ''}  [&QSON]Table:${table_name}[&QSOFF]{/if}
{else}
[&QSON]${order.destination} No:${order.seq|tail:3}[&QSOFF]{if order.table_name != ''}  [&QSON]Table:${table_name}[&QSOFF]{/if}
{/if}
[&CR]
${'Check No:'|left:10}${order.seq|left:13} ${'service:'|left:9}${order.service_clerk_displayname|left:8}
------------------------------------------
{for item in order.display_sequences}
{if item.type == 'item' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
    firstline = _MODIFIERS['substr'](item.name, 0, 32);
    secondline = item.name.substr(firstline.length) || '';
	itemTrans = order.items[item.index];
	count += parseInt(itemTrans.current_qty);
{/eval}
[&DHON]${++index|right:2}${'.'}[&DHOFF][&QSON]${firstline|left:16}[&QSOFF][&DHON]${'x' + order.items[item.index].current_qty|right:6}[&DHOFF]
{if secondline != ''}
   ...[&DHON]${secondline|left:14}[&DHOFF]
{/if}
{elseif item.type == 'setitem' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
    firstline = _MODIFIERS['substr'](item.name, 0, 31);
    secondline = item.name.substr(firstline.length) || '';
{/eval}
   [&QSON]→${firstline|left:14}[&QSOFF][&DHON]${order.items[item.index].current_qty|right:6}[&DHOFF]
{if secondline != ''}
    ...[&QSON]${secondline|left:14}[&QSOFF]
{/if}
{elseif item.type == 'condiment' && (item.index == null || order.items[item.index].linked)}
{eval}
  if (order.items[item.index].parent_index) {
    condimentName = item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 16);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '' + secondline;
  }
  else {
    condimentName = item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 16);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '' + secondline;
  }
{/eval}
   [&DHON]●${firstline|left:30}[&DHOFF]
{if secondline != ''}
       [&DHON]${secondline|left:30}[&DHOFF]
{/if}
{elseif item.type == 'memo' && (item.index == null || order.items[item.index] == null || order.items[item.index].linked)}
{if item.index == null || order.items[item.index] == null}
------------------------------------------
[&DHON]Order Memo：${item.name}[&DHOFF]
{else}
[&DHON]Memo：${item.name}[&DHOFF]
{/if}
{/if}
{/for}
[0x1B][0x32]------------------------------------------
${'Print Time:'|left:12}${(new Date()).toLocaleFormat('%Y-%m-%d %H:%M:%S')}${'*0207A'|right:10}
{if store.country != 0}
${store.country|center:32}
{/if}
[&CR]
[&CR]
[&CR]
[&OPENDRAWER]
[&PC]
{/if}
{/if}