<!-- plugins tpl -->

<!-- navigation bar -->
<div id="nav_bar">
    <a href="javascript:rlSearchPlugins()" class="button_bar">{strip}
        <span class="left"></span>
        <span class="center_search" id="search_plugins">{$lang.search_installed}</span>
        <span class="right"></span>
    {/strip}</a>

    <a href="javascript:rlBrowsePlugins()" class="button_bar">{strip}
        <span class="left"></span>
        <span class="center_list" id="browse_plugins">{$lang.more_plugins}</span>
        <span class="right"></span>
    {/strip}</a>
</div>
<!-- navigation bar end -->

<div id="action_blocks">
    <div id="browse_area" class="hide">
        {include file='blocks'|cat:$smarty.const.RL_DS|cat:'m_block_start.tpl' block_caption=$lang.available_plugins}
            <div id="browse_content"></div>
        {include file='blocks'|cat:$smarty.const.RL_DS|cat:'m_block_end.tpl'}
    </div>

    <div id="search_area" class="hide">
        {include file='blocks'|cat:$smarty.const.RL_DS|cat:'m_block_start.tpl' block_caption=$lang.search}
            <table class="form">
            <tr>
                <td class="name w130">{$lang.name}</td>
                <td class="field">
                    <input class="filters" type="text" id="sp_name" maxlength="60" />
                </td>
            </tr>
            <tr>
                <td class="name w130">{$lang.status}</td>
                <td class="field">
                    <select class="filters w200" id="sp_status">
                        <option value="">{$lang.select}</option>
                        <option value="active">{$lang.active}</option>
                        <option value="approval">{$lang.approval}</option>
                        <option value="not_installed">{$lang.plugin_not_installed}</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td></td>
                <td class="field nowrap">
                    <input type="button" class="button" value="{$lang.search}" id="search_button" />
                    <input type="button" class="button" value="{$lang.reset}" id="reset_search_button" />
                    <a class="cancel" href="javascript:rlSearchPlugins()">{$lang.cancel}</a>
                </td>
            </tr>
            </table>
        {include file='blocks'|cat:$smarty.const.RL_DS|cat:'m_block_end.tpl'}
    </div>
    
    <div id="update_area" class="hide">
        {include file='blocks'|cat:$smarty.const.RL_DS|cat:'m_block_start.tpl'}
        <div id="update_info">
            {assign var='replace_ver' value=`$smarty.ldelim`version`$smarty.rdelim`}
            {assign var='replace_name' value=`$smarty.ldelim`name`$smarty.rdelim`}
            <div>{$lang.plugin_update_request_hint|replace:$replace_ver:'<b><span id="update_version"></span></b>'|replace:$replace_name:'<span id="update_link"></span>'}</div>
            <input id="start_update" type="button" value="{$lang.update}" />
            <a onclick="$('#update_area').slideUp();" class="cancel" href="javascript:void(0);">{$lang.cancel}</a>
        </div>
        <div id="update_progress" class="hide">
            <div class="dark_12"><b id="plugin_name"></b> {$lang.plugin_is_updating}</div>
            <div class="progress static" style="padding: 5px 0 0;">{$lang.remote_progress_backingup}</div>
        </div>
        {include file='blocks'|cat:$smarty.const.RL_DS|cat:'m_block_end.tpl'}
    </div>
</div>

<script type="text/javascript">//<![CDATA[
var actions_locked = false;
var plugin_is_installing_phrase = '{$lang.plugin_is_installing}';
var plugin_updating_phrase = "{$lang.remote_progress_updating}";
var plugin_update_notice = "{$lang.remote_plugin_update_notice}";
var plugin_connect_phrase = "{$lang.remote_progress_connect}";
var plugin_install_notice = "{$lang.remote_plugin_install_notice}";
var plugin_installing_phrase = "{$lang.remote_progress_installing}";
var update_plugin_key;
var plugins_loaded = false;
var plugin_filters = [];
{literal}

$(document).ready(function(){
    $('#start_update').click(function() {
        rlConfirm(plugin_update_notice, 'startUpdate');
    });

    $('#search_button').click(function() {
        rlSearchFetchPlugins();
    });

    $('#sp_name').keypress(function(e) {
        if (e.which == 13) rlSearchFetchPlugins();
    });

    $('#reset_search_button').click(function() {
        $("#sp_status option[value='']").attr('selected', true);
        $("#sp_name").val('');

        pluginsGrid.filters = [];
        pluginsGrid.reset();
    });
});

var rlSearchFetchPlugins = function() {
    var plugin_name = $.trim($('#sp_name').val());
    var plugin_status = $('#sp_status').val();
    plugin_filters = [];

    if (plugin_name.length) {
        plugin_filters.push(['plugin', encodeURI(plugin_name)])
    }

    if (plugin_status.length) {
        plugin_filters.push(['status', plugin_status])
    }

    // reload grid
    pluginsGrid.filters = plugin_filters;
    pluginsGrid.reload();
}

var rlBrowsePlugins = function() {
    if (plugins_loaded) {
        $('#browse_area').slideToggle();
        $('#update_area, #search_area').slideUp('fast');
    }
    else {
        xajax_browsePlugins();
        $('.button_bar > #browse_plugins').html(lang['loading']);
    }
}

var rlSearchPlugins = function() {
    $('#search_area').slideToggle();
    $('#update_area, #browse_area').slideUp('fast');
}

var rlPluginRemoteInstall = function(){
    // install links handler
    $('a.remote_install').click(function(){
        if ( !actions_locked ) {
            plugin_obj = this;
            rlConfirm(plugin_install_notice, 'startInstallation');
        }
    });

    // buy button handler
    $('a.buy_icon').click(function(){
        startBuying($(this), $(this).text());
    });
};

var buyingInterval;
var startBuying = function(button, caption){
    var key = button.attr('name');
    
    window.open('https://www.flynax.ru/buy-plugin.html?key='+key+'&domain={/literal}{$license_domain}&license={$license_number}{literal}', '_blank');

    setTimeout(function(){
        buyingInterval = setInterval('updatePluginStatus("'+key+'")', 5000);
    }, 20000);
}

var updatePluginStatus = function(key){
    // track paid plugins
    $.getJSON(rlUrlHome+'request.ajax.php', {item: 'updatePluginStatus', key: key, {/literal}domain: '{$license_domain}', license: '{$license_number}'{literal}}, function(status){
        // stop checking
        if ( status.status == 'paid' || status.status == 'fail' ) {
            clearInterval(buyingInterval);
        }

        // start plugin installation
        if ( status.status == 'paid' ) {
            $('div.modal-window > div:first > span:last').click();
            plugin_obj = $('ul.browse_plugins a.buy_icon[name='+key+']');
            startInstallation();
        }
    });
}

var startInstallation = function(){
    if (actions_locked) {
        return;
    }

    actions_locked = true;
    
    hideNotices();
    
    var key = $(plugin_obj).attr('name');
    var area = $(plugin_obj).closest('div.changelog_item');
    var name = $(area).find('a:first').html();
    var id = $(area).attr('id');
    var height = $(area).height()-16-2;
    height = height < 55 ? 'auto' : height;
    var width = $(area).width();
    
    /* set fixed height for main container */
    $(area).parent().height($(area).height());
    
    /* prepare HTML DOM */
    var html = ' \
    <div style="margin: 0 10px 16px 0;height: '+ height +'px;width: '+ width +'px;position: absolute;padding: 0;" class="hide grey_area" id="'+ id +'_tmp"> \
        <div style="padding: 8px 10px 10px;"> \
            <div class="dark_13"><b>'+ name +'</b> '+ plugin_is_installing_phrase +'</div> \
            <div class="progress static" style="padding: 5px 0 0;"></div> \
        </div> \
    </div>';
    
    /* show progress bar */
    $(area).after(html);
    $(area).css({width: $(area).width(), position: 'absolute'}).fadeOut();
    $(area).next().fadeIn('normal', function(){
        $(area).css('position', 'relative');
        $(this).css({position: 'relative', width: 'auto'});
        $(this).find('.progress').html(plugin_connect_phrase);
        xajax_remoteInstall(key);
    });
};

var startUpdate = function(){
    $('#update_info').fadeOut(function(){
        $('#update_progress').fadeIn();
        xajax_remoteUpdate(update_plugin_key, true);
    });
};

var continueUpdating = function(key){
    $('div#progress div.progress').html(plugin_updating_phrase);
    xajax_update(key);
};

var continueInstallation = function(key){
    var area = $('div.changelog_item a[name='+ key +']').closest('div.changelog_item');
    $(area).next().find('div.progress').html(plugin_installing_phrase);
    
    xajax_install(key, 'true');
};

var hideProgressBar = function(){
    $('#update_progress').fadeOut();
};

{/literal}
//]]>
</script>

<!-- plugins grid -->
<div id="grid"></div>
<script type="text/javascript">//<![CDATA[
var pluginsGrid;

{literal}
$(document).ready(function(){
    
    pluginsGrid = new gridObj({
        key: 'plugins',
        id: 'grid',
        filters: plugin_filters,
        ajaxUrl: rlUrlHome + 'controllers/plugins.inc.php?q=ext',
        defaultSortField: 'Name',
        title: lang['ext_plugins_manager'],
        fields: [
            {name: 'ID', mapping: 'ID'},
            {name: 'Name', mapping: 'Name', type: 'string'},
            {name: 'Key', mapping: 'Key'},
            {name: 'Description', mapping: 'Description', type: 'string'},
            {name: 'Version', mapping: 'Version'},
            {name: 'Status', mapping: 'Status'},
            {name: 'Compatible', mapping: 'Compatible'}
        ],
        columns: [
            {
                header: lang['ext_name'],
                dataIndex: 'Name',
                width: 30,
                id: 'rlExt_item_bold'
            },{
                header: lang['ext_description'],
                dataIndex: 'Description',
                width: 60
            },{
                header: lang['ext_version'],
                dataIndex: 'Version',
                width: 12
            },{
                header: lang['ext_status'],
                dataIndex: 'Status',
                width: 12,
                editor: new Ext.form.ComboBox({
                    store: [
                        ['active', lang['ext_active']],
                        ['approval', lang['ext_approval']]
                    ],
                    displayField: 'value',
                    valueField: 'key',
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    selectOnFocus:true
                })
            },{
                header: lang['ext_actions'],
                width: 90,
                fixed: true,
                dataIndex: 'Key',
                sortable: false,
                renderer: function(value, obj, row) {
                    var complete = value.split('|');
                    var out = "<center>";

                    if (complete[1] == 'not_installed') {
                        if (row.data.Compatible && row.data.Compatible == true) {
                            out += "<img class='install' title='"+lang['ext_install']+"' src='"+rlUrlHome+"img/blank.gif' onclick='xajax_install(\""+complete[0]+"\");$(this).animate({opacity: 0.5}, \"slow\").attr(\"onclick\", \"\");' />";
                        }
                    } else {
                        out += "<img class='update' title='"+lang['ext_check_for_update']+"' src='"+rlUrlHome+"img/blank.gif' onclick='xajax_checkForUpdate(\""+complete[0]+"\");' />";
                        out += "<img class='uninstall' title='"+lang['ext_uninstall']+"' src='"+rlUrlHome+"img/blank.gif' onclick='rlConfirm( \""+lang['ext_plugin_uninstall']+"\", \"xajax_unInstall\", \""+Array(value)+"\" )' />";
                    }
                    out += "</center>";
                    
                    return out;
                }
            }
        ]
    });
    
    {/literal}{rlHook name='apTplPluginsGrid'}{literal}
    
    pluginsGrid.init();
    grid.push(pluginsGrid.grid);
    
    pluginsGrid.grid.addListener('beforeedit', function(editEvent) {
        if (editEvent.value == 'not_installed' || editEvent.value == lang['incompatible']) {
            editEvent.cancel = true;
            pluginsGrid.store.rejectChanges();
            Ext.MessageBox.alert(
                lang['ext_notice'], 
                editEvent.value == 'not_installed' 
                ? lang['ext_need_install'] 
                : '{/literal}{$lang.plugin_not_compatible_notice}{literal}'
            );
        }
    });
    
});
{/literal}
//]]>
</script>
<!-- plugins grid end -->

{rlHook name='apTplPluginsBottom'}

<!-- plugins tpl end -->
