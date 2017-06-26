{if order.destination_prefix == 1211 || order.destination_prefix == 1212 || order.destination_prefix == 1221 || order.destination_prefix == 1222 || order.destination_prefix == 2211 || order.destination_prefix == 2212 || order.destination_prefix == 2221 || order.destination_prefix == 2222}
{if hasLinkedItems}
[&INIT]
{eval}
  memo = '';
  count = 0;
{/eval}
{eval}
  table_name = order.table_no || '';
  tablesByNo = GeckoJS.Session.get('tablesByNo');
  link_group = order.link_group || '';
  if (tablesByNo) {
    table = tablesByNo[order.table_no];
    if (table) {
      table_name = table.table_name;
    }
  }
  sequence = order.seq.toString();
  if (sequence == null) {
    sequence = '';
  }
  else {
    sequence = sequence.substr(-3);
  }
  count = 0;
  total = 0;
  printObj = {};

  for( i=0; i<order.display_sequences.length; i++){
        if(order.display_sequences[i].type=='item'){
            printObj[order.display_sequences[i].index]= order.items[order.display_sequences[i].index];
            printObj[order.display_sequences[i].index].child = {};
        }
        if(order.display_sequences[i].type=='setitem')
             printObj[order.display_sequences[i].parent_index].child[order.display_sequences[i].index] = order.items[order.display_sequences[i].index];
  }

  for (itemId in printObj) {
        if(order.items[itemId].linked)
            total += order.items[itemId].current_qty;
  }
  groupID = '';
  for(i=0; i<order.display_sequences.length; i++){
       item = order.display_sequences[i];
       if( item.type == 'item' && order.items[item.index] != null && order.items[item.index].linked)       {    groupID = order.items[item.index].link_group;
	    break;
       }
  }
  groupsById = GeckoJS.Session.get('plugroupsById');
  groupName = groupsById[groupID].name;
{/eval}
{eval}
  condStr = '';
  itemTrans = order.items[item.index];
  condiments = itemTrans.condiments;
  count += parseInt(itemTrans.current_qty);
  if (condiments != null) {
    condStr = GeckoJS.BaseObject.getKeys(condiments).join(';');
  }
{/eval}
[&QSON]${groupName|center:21}[&QSOFF][&CR]
{eval}
  header = '主項目共 '+ total +' 項';
{/eval}
{if store.state != ''}
[&QSON]${order.destination}單號:${sequence|tail:2|left:4}[&QSOFF] ${header|right:18}
{else}
[&QSON]${order.destination}單號:${sequence|tail:3|left:4}[&QSOFF] ${header|right:18}
{/if}
{if order.check_no != ''}
[&QSON]取餐號碼:${order.check_no}[&QSOFF]
{/if}
{if order.table_name != ''}
[&QSON]桌名:${table_name|left:14}[&QSOFF]
{/if}
------------------------------------------
{for item in order.display_sequences}
{if item.type == 'item' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
	itemTrans = order.items[item.index];
	count += parseInt(itemTrans.current_qty);
{/eval}
[&QSON]${item.name|left:18}${item.current_qty|right:4}[&QSOFF]
{elseif item.type == 'setitem' && order.items[item.index] != null && order.items[item.index].linked}
[&QSON]${item.name + '※'|left:18}${item.current_qty|right:4}[&QSOFF]
{elseif item.type == 'condiment' && (item.index == null || order.items[item.index].linked)}
      [&DHON]${item.name|left:32}[&DHOFF]
{elseif item.type == 'memo' && (item.index == null || order.items[item.index] == null || order.items[item.index].linked)}
{if item.index == null || order.items[item.index] == null}
{eval}
if (memo.length == 0)
    memo += ((memo.length == 0) ? '' : '\n') + item.name
{/eval}
{else}
     備註:${item.name|left:31}
{/if}
{/if}
{/for}
------------------------------------------
[&QSON]${'總計:' + count + '項' + ' ' +order.total + '元'}[&QSOFF]
------------------------------------------
${'時間:'|left:6}${(new Date()).toLocaleFormat('%m-%d %H:%M:%S')} ${'機:' + order.terminal_no|left:13}${'*0207B'|right:8}
[&CR]
{if memo.length > 0}
${memo|left:42}
{/if}
[&CR]
[&CR]
[&CR]
[&PC]
[&OPENDRAWER]
{/if}
{/if}