/**
 * Created by JetBrains RubyMine.
 * User: simone
 * Date: 08/12/11
 * Time: 11:03
 * To change this template use File | Settings | File Templates.
 */

$(function () {
    var registrationDay = new Date(2011,12-1,12,12,0,0);
    $('#countdown').countdown(
        {
            until: registrationDay,
            timezone: +60,
            significant: 4,
            //layout:'<div><span>{dn}</span>:<span>{hn}</span>:<span>{mn}</span>:<span>{sn}</span></div>',
            description: 'all\'apertura delle iscrizioni',
            expiryUrl: '/attendees/new'
        }
    );
});
