<?php

/******************************************************************************
 *  
 *  PROJECT: Flynax Classifieds Software
 *  VERSION: 4.8.0
 *  LICENSE: RU9018RLF896 - https://www.flynax.ru/user-agreement.html
 *  PRODUCT: Real Estate Classifieds
 *  DOMAIN: domozhil.ru
 *  FILE: INDEX.PHP
 *  
 *  The software is a commercial product delivered under single, non-exclusive,
 *  non-transferable license for one domain or IP address. Therefore distribution,
 *  sale or transfer of the file in whole or in part without permission of Flynax
 *  respective owners is considered to be illegal and breach of Flynax License End
 *  User Agreement.
 *  
 *  You are not allowed to remove this information from the file without permission
 *  of Flynax respective owners.
 *  
 *  Flynax Classifieds Software 2020 | All copyrights reserved.
 *  
 *  https://www.flynax.ru
 ******************************************************************************/

/* template settings */
$tpl_settings = array(
    'type' => 'responsive_42', // DO NOT CHANGE THIS SETTING
    'version' => 1.1,
    'name' => 'realty_nova',
    'inventory_menu' => false,
    'category_menu' => false,
    'right_block' => false,
    'long_top_block' => false,
    'featured_price_tag' => true,
    'ffb_list' => false, //field bound boxes plugins list
    'fbb_custom_tpl' => true,
    'header_banner' => true,
    'header_banner_size_hint' => '728x90',
    'home_page_gallery' => false,
    'autocomplete_tags' => true,
    'category_banner' => false,
    'shopping_cart_use_sidebar' => true,
    'listing_details_anchor_tabs' => true,
    'search_on_map_page' => true,
    'home_page_map_search' => true,
    'browse_add_listing_icon' => false,
    'listing_grid_except_fields' => array('title', 'bedrooms', 'bathrooms', 'square_feet', 'time_frame', 'phone', 'pay_period'),
    'category_dropdown_search' => true,
    'sidebar_sticky_pages' => array('listing_details'),
    'sidebar_restricted_pages' => array('search_on_map'),
    'qtip' => array(
        'background' => '1473cc',
        'b_color'    => '1473cc',
    ),
);

if ( is_object($rlSmarty) ) {
    $rlSmarty -> assign_by_ref('tpl_settings', $tpl_settings);
}

// Insert configs and hooks
if (!isset($config['nova_support'])) {
    // set phrases
    $reefless->loadClass('Lang');
    $languages = $rlLang->getLanguagesList();
    $tpl_phrases = array(
        array('admin', 'nova_category_menu', 'Category menu'),
        array('admin', 'nova_category_icon', 'Category Icon'),
        array('admin', 'nova_load_more', 'Load More'),
        array('frontEnd', 'home_page_h3', 'YourDomain.com is known for providing access to fine international estates and property listings.'),
        array('frontEnd', 'pages+h1+home', 'The best way to find your home'),
        array('frontEnd', 'nova_mobile_apps', 'Mobile Apps'),
        array('frontEnd', 'footer_menu_1', 'About Classifieds'),
        array('frontEnd', 'footer_menu_2', 'Help & Contact'),
        array('frontEnd', 'footer_menu_3', 'More Helpful Links'),
        array('frontEnd', 'nova_load_more_listings', 'Load More Listings'),
        array('frontEnd', 'contact_email', 'sales@flynax.com'),
        array('frontEnd', 'phone_number', '+1 (994) 546-1212'),
        array('admin', 'config+name+ios_app_url', 'iOS app url'),
        array('admin', 'config+name+android_app_url', 'Android app url'),
        array('admin', 'config+name+android_app_url', 'Android app url'),
        array('admin', 'config+name+home_map_search', 'Map search on home page'),
        array('frontEnd', 'nova_newsletter_text', 'Subscribe for our newsletters and stay updated about the latest news and special offers.'),
    );

    // insert template phrases
    foreach ($languages as $language) {
        foreach ($tpl_phrases as $tpl_phrase) {
            if (!$rlDb -> getOne('ID', "`Code` = '{$language['Code']}' AND `Key` = '{$tpl_phrase[1]}'", 'lang_keys')) {
                $sql = "INSERT IGNORE INTO `". RL_DBPREFIX ."lang_keys` (`Code`, `Module`, `Key`, `Value`, `Plugin`) VALUES ";
                $sql .= "('{$language['Code']}', '{$tpl_phrase[0]}', '{$tpl_phrase[1]}', '". $rlValid->xSql($tpl_phrase[2])."', 'nova_template');";
                $rlDb -> query($sql);
            }
        }
    }

    // Insert configs
    $insert_setting = array(
        array(
            'Group_ID' => 0,
            'Key' => 'nova_support',
            'Default' => 1,
            'Type' => 'text',
            'Plugin' => 'nova_template'
        ),
        array(
            'Group_ID' => 1,
            'Position' => 36,
            'Key' => 'ios_app_url',
            'Default' => 'https://itunes.apple.com/us/app/iflynax/id424570449?mt=8',
            'Type' => 'text',
            'Plugin' => 'nova_template'
        ),
        array(
            'Group_ID' => 1,
            'Position' => 36,
            'Key' => 'android_app_url',
            'Default' => 'https://play.google.com/store/apps/details?id=com.flynax.flydroid&hl=en_US',
            'Type' => 'text',
            'Plugin' => 'nova_template'
        ),
        array(
            'Group_ID' => 14,
            'Position' => 10,
            'Key' => 'home_map_search',
            'Default' => '0',
            'Type' => 'bool',
            'Plugin' => 'nova_template'
        )
    );
    $rlDb->insert($insert_setting, 'config');

    // Enable home page h1
    $rlDb->query("UPDATE `{db_prefix}config` SET `Default` = '1' WHERE `Key` = 'home_page_h1' LIMIT 1");

    // Increase max visible categories in box
    $rlDb->update(array(
        'fields' => array('Ablock_visible_number' => 18),
        'where' => array('Key' => 'listings')
    ), 'listing_types');

    // insert hooks
    $db_prefix = RL_DBPREFIX;
    $sql = <<< MYSQL
INSERT INTO `{db_prefix}hooks` (`Name`, `Plugin`, `Class`, `Code`, `Status`) VALUES
('ajaxRequest', 'nova_template', '', 'if (\$param2 != ''novaLoadMoreListings'') {\r\n    return;\r\n}\r\n\r\nglobal \$rlSmarty, \$config, \$reefless, \$rlDb, \$rlListings;\r\n\r\n\$type  = \$_REQUEST[''type''];\r\n\$key   = \$_REQUEST[''key''];\r\n\$total = \$_REQUEST[''total''];\r\n\$ids   = explode('','', \$_REQUEST[''ids'']);\r\n\r\n\$results   = array();\r\n\$page_info = array(\r\n    ''Controller'' => ''home'',\r\n    ''Key'' => ''home'',\r\n);\r\n\r\n\$reefless->loadClass(''Listings'');\r\n\r\n\$rlSmarty->assign(''side_bar_exists'', \$_REQUEST[''side_bar_exists'']);\r\n\$rlSmarty->assign(''block'', array(''Side'' => \$_REQUEST[''block_side'']));\r\n\r\n\$rlListings->selectedIDs = \$ids;\r\n\r\nif (\$type == ''featured'') {\r\n    \$value = '''';\r\n    \$field = '''';\r\n\r\n    if (\$pos = strpos(\$key, ''_box'')) {\r\n        \$value = substr(\$key, -1);\r\n        \$key   = substr(\$key, 0, \$pos);\r\n        \$field = \$GLOBALS[''rlListingTypes'']->types[\$key][''Arrange_field''];\r\n    }\r\n\r\n    \$limit      = \$config[''featured_per_page''];\r\n    \$next_limit = \$limit <= 5 ? \$limit * 2 : \$limit;\r\n    \$tpl        = ''blocks'' . RL_DS . ''featured.tpl'';\r\n    \$listings   = \$rlListings->getFeatured(\$key, \$next_limit, \$field, \$value);\r\n    \$count      = count(\$listings);\r\n    \$next       = \$total + \$count < \$rlListings->calc;\r\n\r\n    \$rlSmarty->assign_by_ref(''listings'', \$listings);\r\n} else {\r\n    \$reefless->loadClass(''ListingsBox'', null, ''listings_box'');\r\n\r\n    \$box_id     = str_replace(''listing_box_'', '''', \$key);\r\n    \$box_info   = \$rlDb->fetch(\r\n        ''*'',\r\n        array(''ID'' => \$box_id),\r\n        null, 1, ''listing_box'', ''row''\r\n    );\r\n    \$limit      = \$box_info[''Count''];\r\n    \$next_limit = \$limit <= 5 ? \$limit * 2 : \$limit;\r\n    \$tpl        = RL_PLUGINS . ''listings_box'' . RL_DS . ''listings_box.block.tpl'';\r\n    \$listings   = \$GLOBALS[''rlListingsBox'']->getListings(\r\n        \$box_info[''Type''],\r\n        \$box_info[''Box_type''],\r\n        \$next_limit,\r\n        1,\r\n        \$box_info[''By_category'']\r\n    );\r\n    \$count      = count(\$listings);\r\n    \$next       = true;\r\n\r\n    \$box_option = array(\r\n        ''display_mode'' => \$box_info[''Display_mode'']\r\n    );\r\n\r\n    \$rlSmarty->assign(''box_option'', \$box_option); \r\n    \$rlSmarty->assign_by_ref(''listings_box'', \$listings);\r\n}\r\n\r\nif (\$listings) {\r\n    \$rlSmarty->preAjaxSupport();\r\n\r\n    \$results = array(\r\n        ''next''  => \$next,\r\n        ''count'' => \$count,\r\n        ''ids''   => \$rlListings->selectedIDs,\r\n        ''html''  => \$rlSmarty->fetch(\$tpl, null, null, false)\r\n    );\r\n\r\n    \$rlSmarty->postAjaxSupport(\$results, \$page_info, \$tpl);\r\n}\r\n\r\n\$param1 = array(\r\n    ''status'' => ''OK'',\r\n    ''results'' => \$results\r\n);', 'active'),
('listingsModifyPreSelectFeatured', 'nova_template', '', 'if (\$_REQUEST[''mode''] == ''novaLoadMoreListings'') {\r\n    \$param1 = true;\r\n}', 'active'),
('apTplContentBottom', 'nova_template', '', 'global \$controller, \$config;\r\n\r\nif (\$controller != ''settings'') return;\r\n\r\n\$out = <<< JAVASCRIPT\r\n<script>\r\n(function(){\r\n    var option = function(){\r\n        var row = \$(''#home_map_search_1'').closest(''tr'');\r\n        var name = \$(''select[name=\"post_config[template][value]\"]'').val();\r\n\r\n        if (name == ''realty_nova'') {\r\n            row.show();\r\n        } else {\r\n            row.hide();\r\n        }\r\n    }\r\n\r\n    option();\r\n\r\n    \$(''select[name=\"post_config[template][value]\"]'').change(function(){\r\n        option();\r\n    });\r\n})();\r\n</script>\r\nJAVASCRIPT;\r\n\r\necho \$out;', 'active');
MYSQL;
    $rlDb -> query($sql);

    // update page for fetch new hooks in system
    if (defined('REALM') && REALM == 'admin') {
        $reefless->referer();
    }
}
