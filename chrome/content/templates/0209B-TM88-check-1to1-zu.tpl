{if order.destination_prefix == 1211 || order.destination_prefix == 1212 || order.destination_prefix == 1221 || order.destination_prefix == 1222 || order.destination_prefix == 2211 || order.destination_prefix == 2212 || order.destination_prefix == 2221 || order.destination_prefix == 2222}
{if hasLinkedItems}
[&INIT]
{eval}
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
{/eval}
{for item in printObj}
{if item.linked}
{eval}
  table_name = order.table_no || '';
  tablesByNo = GeckoJS.Session.get('tablesByNo');
  if (tablesByNo) {
    table = tablesByNo[order.table_no];
    if (table) {
      table_name = table.table_name;
    }
  }
  condStr = '';
  condiments = item.condiments;
  if (condiments != null) {
    condStr = GeckoJS.BaseObject.getKeys(condiments).join(';');
  }
  if (defined(item.alt_name1) && item.alt_name1 != '') {
    name = item.alt_name1;
  }
  else {
    name = item.name;
  } 

  itemLen = new Array();

    for (var i = 0; i < item.current_qty; i++) {
        itemLen.push(i);
    }
{/eval}
{for index in itemLen}
{eval}
  header = '第 '+ ++count+' 項/共 '+total+' 項';
{/eval}
{if order.destination == '內用'}
[&OSON]單${sequence|tail:3} ${'桌' + table_name|left:7}[&OSOFF]
{elseif order.destination == '桌外帶'}
[&OSON]單${sequence|tail:3} ${'桌' + table_name}外帶[&OSOFF]
{elseif order.destination == '外用'}
[&OSON]單${sequence|tail:3} ${'外用'}[&OSOFF]
{elseif order.destination == '外帶'}
[&OSON]單${sequence|tail:3} ${'外帶'}[&OSOFF]
{else}
[&OSON]單${sequence|tail:3}  ${order.destination}[&OSOFF]
{/if}
{if order.check_no != ''}
[&QSON]取餐號碼:${order.check_no}[&QSOFF]
{/if}
------------------------------------------
[&OSON]${item.name + 'x1'|right:16}[&OSOFF]
{if condStr != ''}
[&QSON] ${condStr|right:18}[&QSOFF]
{/if}
{for child in item.child}
{eval}
  childcondStr = '';
  childcondiments = child.condiments;
  if (childcondiments != '') {
    condStr = GeckoJS.BaseObject.getKeys(childcondiments).join(';');
  }
  if (child.alt_name1 != '') {
    childname = child.alt_name1;
  }
  else {
    childname = child.name;
  }
{/eval}
[&QSON] →${childname|left:15}${'x 1'|right:3}[&QSOFF]
{if condStr != ''}
[&QSON] ${condStr|left:18}[&QSOFF]
{/if}
{/for}
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
[&OPENDRAWER]
{/for}
{/if}
{/for}
{/if}
{/if}