[&INIT]
{eval}
  sequence = order.seq.toString();
  if (!defined(sequence) || sequence == null) {
    sequence = '';
  }
  else {
    sequence = sequence.substr(-2);
  }
{/eval}
{if order.destination == '外帶'}
[&OSON]外:${sequence}[&OSOFF]
{else}
[&OSON]內:${order.table_no}[&OSOFF]
{/if}
[&CR]
{for item in order.items}
{eval}
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
{/eval}
[&QSON]${name|left:17} ${item.current_qty|right:3}[&QSOFF]
{if condStr && condStr != ''}
[&DHON]  ${condStr|left:40}[&DHOFF]
{/if}
{/for}
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
