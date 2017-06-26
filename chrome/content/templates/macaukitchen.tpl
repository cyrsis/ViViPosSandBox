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
GREUtils.log(GeckoJS.BaseObject.dump(printObj));
{/eval}

{for item in printObj}
{if item.linked}
{eval}
  conds = GeckoJS.BaseObject.getKeys(item.condiments);
  if (defined(item.alt_name1) && item.alt_name1 != '') {
    name = item.alt_name1;
  }
  else {
    name = item.name;
  }

{/eval}
{eval}
count += item.current_qty;
header = count + '/' + total;
{/eval}
{if item.current_qty >= 0 || item.current_qty == 0}
{if order.destination_prefix == 200}
[0x1B][0x72][0x01]
[&QSON]${'外賣 DLV:' + order.check_no }  ${header}[&QSOFF]
[0x1B][0x72][0x00]
{else}
[&QSON]${'Table:' + order.table_name} ${'No#:'+ order.check_no}${header|right:6}[&QSOFF]
{/if}
[&QSON]${'Time:' + new Date().toLocaleFormat('%H:%M')|left:18}[&QSOFF]
[&QSON]${'Waitress:'|left:10}${order.service_clerk_displayname|left:16}[&QSOFF]
-------------------------------------
[&CR]
{if order.destination_prefix == 200 ||item.memo=='ToGo'}
[0x1B][0x72][0x01]
[&QSON] TO GO (外賣盒上)[&QSOFF]
[0x1B][0x72][0x00]
{/if}
{if item.current_qty>1}
[&REDON]
[&QSON]${name}[&QSOFF] [&QSON]${'X'+item.current_qty|right:3}[&QSOFF]
[&QSON]${item.alt_language}[&QSOFF]
[&REDOFF]
{else}
[&QSON]${name}[&QSOFF] [&QSON]${'X'+item.current_qty|right:3}[&QSOFF]
[&QSON]${item.alt_language}[&QSOFF]
{/if}
{if item.condiments != null}
{for cond in conds}
[&QSON]  ${cond}X${item.condiments[cond].current_qty}[&QSOFF]
{/for}
{/if}
{for child in item.child}
{eval}
  childcondStr = '';
  childcondiments = child.condiments;
  if (childcondiments != null) {
    conds= GeckoJS.BaseObject.getKeys(childcondiments);
  }
  if (defined(child.alt_name1) && child.alt_name1 != '') {
    childname = child.alt_name1;
  }
  else {
    childname = child.name;
  }
{/eval}
[&QSON]    ${childname|left:10}${childname.current_qty}[&QSOFF]
{for cond in conds}
[&QSON]    ${cond}X${childcondiments[cond].current_qty}[&QSOFF]
{/for}
{/for}
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
{/if}
{/if}
{/for}
[&CR]
[&CR]
{/if}
