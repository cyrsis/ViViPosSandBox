{if order.destination_prefix == 1112 || order.destination_prefix == 1122 || order.destination_prefix == 1212 || order.destination_prefix == 1222 || order.destination_prefix == 2112 || order.destination_prefix == 2122 || order.destination_prefix == 2212 || order.destination_prefix == 2222}
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
{if store.branch != ''}
[&QSON]${store.branch|center:21}[&QSOFF]
{/if}
{if store.telephone1 != ''}
[&QSON]${store.telephone1|center:21}[&QSOFF]
{/if}
[&CR]
{if store.state != ''}
[&QSON]${'等候单号:'|left:10}第 ${order.seq|tail:2} 号[&QSOFF]
{else}
[&QSON]${'等候单号:'|left:10}第 ${order.seq|tail:3} 号[&QSOFF]
{/if}
[&CR]
[&DHON]${'时间:'|left:6}${(new Date()).toLocaleFormat('%Y-%m-%d  %H:%M')}   ${count + '项' + ' ' + order.total + '元'}[&DHOFF]
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
{/if}