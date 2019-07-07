window.espn = window.espn || {};
window.espn.trackAndClear = function( props ) {
  if ( props && espn.track ) {
    espn.track.trackLink( props );
    espn.track.set({ linkGroup: null });
  }
};
window.espn.abcnTrackOmni = function( obj ) {
  var linkTrackVars = [];
  var linkTrackEvents = [];
  var linkName;
  var lncnt = 0;
  if ( obj ) {
    Object.keys( obj ).forEach( function( i ) {
      lncnt++;
      if ( 'events' === i ) {
        linkTrackEvents.push( obj[i]);
      }
      linkTrackVars.push( i );
      window.s_omni[i] = obj[i];
      if ( lncnt === Object.keys( obj ).length ) {
        window.s_omni.linkTrackEvents = linkTrackEvents.join();
        window.s_omni.linkTrackVars = linkTrackVars.join();
        linkName =  window.s_omni.eVar24 || window.s_omni.prop16;
        window.s_omni.tl( obj, 'o', linkName );
      }
    });
  }
};

var jQuery = typeof jQuery !== 'undefined' ? jQuery : function (arg) {

  this.on = function (ev, callback) {
    var nodes = document.querySelectorAll(arg);
    for (var i=0; i<nodes.length; i++) {
      nodes[i].addEventListener(ev, callback);
    }
    return jQuery;
  }

  this.ready = function (callback) {
    document.addEventListener('DOMContentLoaded', function (e) {
      if (typeof callback === 'function') {
        callback(jQuery);
      }
    });
  }

  return this;
}

function getDeviceType () {
	var e = window, a = 'inner';
	if ( ! ( 'innerWidth' in window ) ) {
		a = 'client';
		e = document.documentElement || document.body;
	}
  var width = e[a + 'Width'];
  return width <= 768 ? 'Smartphone' : (width <= 1024 ? 'Tablet' : 'Desktop');
}

  window.pageSection = {
    'life': 'culture'
  }[trackingConfig.section] || trackingConfig.section;
  window.___skipShowAds = (navigator.userAgent && navigator.userAgent.indexOf('Electron') > -1) || (window.location && window.location.search && window.location.search.indexOf('skipads') >= 0);
  var FTEChartbeat = {
    uid: "12240",
    domain: "fivethirtyeight.com",
    path: "/" + trackingConfig.path,
    sections: pageSection,
    authors: trackingConfig.author
  };
  var FTENielsen = {
    asset_id: trackingConfig.postId + ":" + trackingConfig.title,
    section: pageSection,
    seg_a: "",
    seg_b: "",
    seg_c: ""
  };
  var ESPNOmniture = {
    omniture: {
      pageName: trackingConfig.section + ":interactives:" + trackingConfig.pageName,
      prop1: "fivethirtyeight",
      prop2: '',
      prop5: "interactives",
      prop6: trackingConfig.author,
      prop7: pageSection,
      prop12: trackingConfig.title,
      prop13: trackingConfig.postId + ":" + trackingConfig.title,
      prop14: "",
      prop15: trackingConfig.fullUrl,
      prop16: trackingConfig.fullUrl,
      prop20: getDeviceType(),
      prop23: trackingConfig.primaryTag,
      eVar5: "interactives",
      eVar6: trackingConfig.author,
      eVar7: pageSection,
      eVar9: trackingConfig.publishTime.split(' ')[0],
      eVar10: trackingConfig.publishTime.split(' ')[1],
      eVar12: trackingConfig.title,
      eVar13: trackingConfig.postId + ":" + trackingConfig.title,
      eVar14: "",
      eVar15: trackingConfig.fullUrl,
      eVar16: trackingConfig.fullUrl,
      eVar20: getDeviceType()
    },
    account: "wdgnewfivethirtyeight",
    chartbeat: {
      domain: "fivethirtyeight.com",
      path: trackingConfig.path,
      title: trackingConfig.title,
      loadPubJS: false,
      loadVidJS: true,
      sections: pageSection,
      authors: trackingConfig.author
    }
  };


<!-- ABC update //-->
function analyticsInit () {
  var cb, node;
  if ( 'undefined' !== typeof FTEChartbeat ) {
    window._sf_startpt = ( new Date() ).getTime();
    window._sf_async_config = window._sf_async_config || {};
    window._sf_async_config.useCanonical = true;
    window._sf_async_config.useCanonicalDomain = true;
    window._sf_async_config.flickerControl = false;
    window._sf_async_config.uid = FTEChartbeat.uid;
    window._sf_async_config.domain = FTEChartbeat.domain;
    window._sf_async_config.path = FTEChartbeat.path;
    window._sf_async_config.sections = FTEChartbeat.sections;
    window._sf_async_config.authors = FTEChartbeat.authors;

    cb = document.createElement( 'script' );
    node = document.getElementsByTagName( 'script' )[0];
    cb.async = true;
    cb.type = 'text/javascript';
    cb.src = 'https://static.chartbeat.com/js/chartbeat_mab.js';
    node.parentNode.insertBefore( cb, node );

    cb = document.createElement( 'script' );
    node = document.getElementsByTagName( 'script' )[0];
    cb.async = true;
    cb.type = 'text/javascript';
    cb.src = 'https://static.chartbeat.com/js/chartbeat.js';
    node.parentNode.insertBefore( cb, node );
  }

  jQuery( document ).ready( function( $ ) {
    if ( 'undefined' !== typeof ESPNOmniture ) {

      function bkInit() {
          try {
            bk_addPageCtx( 'prop5', ESPNOmniture.omniture.prop5 ); //-> Content Type
            bk_addPageCtx( 'prop15', ESPNOmniture.omniture.prop16 ); //-> URL as pagenames
            bk_addPageCtx( 'eVar20', ESPNOmniture.omniture.eVar20 ); //-> Platform
            bk_addPageCtx( 'prop18', ESPNOmniture.omniture.prop18 ); //-> New or repeat visitor
          } catch ( e ) {
            console.log( e );
            console.error( 'Error initializing bluekai' );
          }

          window.bk_allow_multiple_calls = true;
          window.bk_use_multiple_iframes = true;

          BKTAG.doTag( 25193, 10 );
      };

      function slideLoadJS( u, c ) {
        var d = document,
        t = 'script',
        o = d.createElement( t ),
        s = d.getElementsByTagName( t )[0];
        o.src = u;
        if ( c ) {
          o.addEventListener( 'load', function( e ) {
            c( null, e );
          }, false );
        }
        s.parentNode.insertBefore( o, s );
      }

      slideLoadJS( 'https://tags.bkrtx.com/js/bk-coretag.js', function() {
        if ( typeof BKTAG !== 'undefined' ) {
          bkInit();
        }
      });
    }
  });

  var nSdkInstance;
  var nielsenMetadata;

  if ( 'undefined' !== typeof FTENielsen ) {

    ! ( function( t, n ) {
    t[n] = t[n] || {nlsQ: function( e, o, c, r, s, i ) {
    return s = t.document, r = s.createElement( 'script' ), r.async = 1, r.src = 'https://cdn-gl.imrworldwide.com/conf/' + e + '.js#name=' + o + '&ns=' + n, i = s.getElementsByTagName( 'script' )[0], i.parentNode.insertBefore( r, i ), t[n][o] = t[n][o] || {g: c || {}, ggPM: function( e, c, r, s, i ) {
    ( t[n][o].q = t[n][o].q || []).push([ e, c, r, s, i ]);
    }}, t[n][o];
    }};
    }( window, 'NOLBUNDLE' ) );

    nSdkInstance = NOLBUNDLE.nlsQ( 'PF2155097-E1B7-4900-A8F3-22BADF34DBC6', 'nlsnInstance', {});

    nielsenMetadata = {
      type: 'static',
      assetid: FTENielsen.asset_id, // *DYNAMIC METADATA*: unique ID for each article **REQUIRED**
      section: FTENielsen.section, // *DYNAMIC METADATA*: section of site **REQUIRED**
      segA: FTENielsen.seg_a, // *DYNAMIC METADATA*: custom segment
      segB: FTENielsen.seg_b, // *DYNAMIC METADATA*: custom segment
      segC: FTENielsen.seg_c	// *DYNAMIC METADATA*: custom segment
      };

    nSdkInstance.ggPM( 'staticstart', nielsenMetadata );
  }

  var _comscore = _comscore || [];
  _comscore.push({ c1: '2', c2: '3000032' });
  ( function() {
    var s = document.createElement( 'script' ),
  el = document.getElementsByTagName( 'script' )[0];
    s.async = true;
    s.src = 'https://sb.scorecardresearch.com/beacon.js';
    el.parentNode.insertBefore( s, el );
  }() );

  jQuery( document ).ready( function( $ ) {

    var sCodeScript;
    var podOmni;

    /**
     * Handle the trackLink calls for podcasts
     */
    var updateForPodcast = function( element, event, status ) {
    var events, prop9, prop38, aodPlayerLine, postID, postTitle, idAndTitle,
  $element = $( element );

      aodPlayerLine = 'fivethirtyeight:aodplayer';
      postID = $element.data( 'podcast-id' );
      postTitle = $element.data( 'podcast-title' );

      switch ( status ) {
        case 'playing':
          idAndTitle = postID + ':' + postTitle + ':play';
          prop38 = 'clip play';
          break;
        case 'paused':
          idAndTitle = postID + ':' + postTitle + ':paused';
          prop38 = 'clip paused';
          break;
        case '5min':
          idAndTitle = postID + ':' + postTitle + ':5-min';
          prop38 = 'clip 5-min';
          break;
        case 'ended':
          idAndTitle = postID + ':' + postTitle + ':complete';
          prop38 = 'clip complete';
          break;
      }


      window.espn.abcnTrackOmni({
        eVar37: idAndTitle,
        prop37: idAndTitle,
        eVar38: prop38,
        prop38: prop38
      });

    };

    /**
     * Update for social clicks
     *
     * @param element
     * @param linkId
     */
    var updateForSocial = function( linkId, event ) {
      window.espn.abcnTrackOmni({
        events: 'event10',
        eVar34: linkId,
        link: event.target
      });
    };

    var bindHandlers = function() {
      $( '.share-twitter' ).on( 'click', function( event ) {
        updateForSocial( 'twitter', event );
      });

      $( '.share-sticky.sticky-facebook' ).on( 'click', function( event ) {
        updateForSocial( 'facebook-sticky', event );
      });

      $( '.share-sticky.sticky-twitter' ).on( 'click', function( event ) {
        updateForSocial( 'twitter-sticky', event );
      });

      $( '.share-facebook' ).on( 'click', function( event ) {
        updateForSocial( 'facebook', event );
      });

      $( '.share-print' ).on( 'click', function( event ) {
        updateForSocial( 'print', event );
      });

      $( '.share-email' ).on( 'click', function( event ) {
        updateForSocial( 'emailshare', event );
      });

      $( '#searchform' ).on( 'submit', function( event ) {
        window.espn.abcnTrackOmni({
          link: event.target,
          linkPos: window.s_omni.prop4,
          linkId: 'search',
          site: 'fivethirtyeight',
          pageName: window.s_omni.pageName,
          section: window.s_omni.channel
        });
      });

      // Podcasts fire 4 events: play, pause, 5min marker, and ended
      // Look into podcast-player.js for more info on the events
      /*
      $( '.js-podcast-player' ).on( 'playing', function( event ) {
        updateForPodcast( this, event, 'playing' );
      }).on( 'paused', function( event ) {
        updateForPodcast( this, event, 'paused' );
      }).on( '5min', function( event ) {
        updateForPodcast( this, event, '5min' );
      }).on( 'ended', function( event ) {
        updateForPodcast( this, event, 'ended' );
      });
      */
    };

    var isRepeatUser = function() {
      /*
      if ( 'true' === $.cookie( 'repeatUser' ) ) {
        return true;
      } else {
        $.cookie( 'repeatUser', true, { path: '/', expires: 9999 });
        return false;
      }
      */
      if (document.cookie.split(';').filter(function(item) {
          return item.indexOf('repeatUser=true') >= 0;
      }).length > 0) {
        return true;
      }
      var d = new Date();
      d.setYear(9999);
      console.log(d);
      document.cookie = 'repeatUser=true; expires=' + d + '; path=/';
    };

    var abcnLinkTrack = function() {
      var articleLinks = document.querySelectorAll( 'a[name]' );
      var i;
      var nameAttr;
      var handler = function( event ) {
        nameAttr = event.target.attributes.name.nodeValue;
        window.espn.abcnTrackOmni({
          eVar24: nameAttr,
          events: 'event10'
        });
        return false;
      };
      for ( i = 0; i < articleLinks.length; i++ ) {
        articleLinks[i].addEventListener( 'click', handler );
      }
    };


    window.updateOmnitureData = function() {
      var livePressPrefix = '#livepress-update-';
      var storyId, storyTitle;

      if ( 0 === window.location.hash.indexOf( livePressPrefix ) ) {
        storyId = window.location.hash.substr( livePressPrefix.length );
        storyTitle = $( '#' + window.location.hash.substr( 1 )  + ' .livepress-update-header' ).text();
        if ( ! storyTitle ) {
          storyTitle = $( 'h1' ).text().trim();
        }
        ESPNOmniture.omniture.prop13 = storyId + ':' + storyTitle;
        ESPNOmniture.omniture.eVar13 = ESPNOmniture.omniture.prop13;
      }

      ESPNOmniture.omniture.eVar18 = ( isRepeatUser() ) ? 'Repeat' : 'New';
      ESPNOmniture.omniture.prop18 = ESPNOmniture.omniture.eVar18;

      window.s_omni.eVar33 = window.s_omni.getDaysSinceLastVisit( 's_v33' ); //days since last visit
      window.s_omni.eVar33 = unescape( window.s_omni.eVar33 ); // handles standard decoding

      Object.keys( ESPNOmniture.omniture ).forEach( function( item ) {
        window.s_omni[item] = ESPNOmniture.omniture[item];
      });

      window.sCode = window.s_omni.t();
      if ( window.sCode ) {
        document.write( window.sCode );
      }

      bindHandlers();
    };

    if ( 'undefined' === typeof ESPNOmniture ) {
      return;
    }

    window.s_account = ESPNOmniture.account;

    sCodeScript = document.createElement( 'script' );
    node = document.getElementsByTagName( 'script' )[0];
    sCodeScript.async = true;
    sCodeScript.type = 'text/javascript';
    sCodeScript.src = 'https://s.abcnews.com/assets/js/s_code_538.js?v=' + new Date().toISOString().slice(0,10).replace(/-/g,"");
    node.parentNode.insertBefore( sCodeScript, node );
    sCodeScript.onload = function() {
      window.s_omni.doPlugins = function() {};
      window.updateOmnitureData();
    };
  });

  if (!window.gtmAdded) {
    window.gtmAdded = true;

    <!-- Google Tag Manager -->
    (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
    new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
    j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
    'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
    })(window,document,'script','dataLayer','GTM-KLHT6T2');
    <!-- End Google Tag Manager -->

    <!-- Google Tag Manager (noscript) -->
    var gtmIframe = document.createElement('iframe');
    gtmIframe.src = "https://www.googletagmanager.com/ns.html?id=GTM-KLHT6T2";
    gtmIframe.width = "0";
    gtmIframe.height = "0";
    gtmIframe.style.display = "none";
    document.body.appendChild(gtmIframe);
    <!-- End Google Tag Manager (noscript) -->
  }

  if (!window.taboolaAdded) {
    window.taboolaAdded = true;


    var related = document.getElementById('related');
    if (related) {
      window.ESPNTaboola = {"publisher":"abcnews-fivethirtyeight","type":"photo"};

      window._taboola = window._taboola || [];

      var taboola = document.createElement( 'script' );
      var node = document.getElementsByTagName( 'script' )[0];
      taboola.async = true;
      taboola.type = 'text/javascript';
      taboola.src = 'https://cdn.taboola.com/libtrc/' + ESPNTaboola.publisher + '/loader.js';
      taboola.id = 'tb_loader_script';
      node.parentNode.insertBefore( taboola, node );

      if ( window.performance && 'function' === typeof window.performance.mark ) {
        window.performance.mark( 'tbl_ic' );
      }

      var div = document.createElement('div');
      div.className = 'taboola-placeholder taboola-recommendations';
      div.setAttribute('id', 'taboola-' + trackingConfig.postId);
      related.parentNode.insertBefore(div, related.nextSibling);

      window._taboola.push({
        mode: 'thumbnails-c',
        container: 'taboola-' + trackingConfig.postId,
        placement: 'Below Article Thumbnails',
        target_type: 'mix'
      });

      window._taboola.push( { 'photo': 'auto', 'url': trackingConfig.fullUrl } );
    }
  }

}

function getScript(source, callback) {
    var script = document.createElement('script');
    var prior = document.getElementsByTagName('script')[0];
    script.async = 1;
    prior.parentNode.insertBefore(script, prior);
    script.onload = script.onreadystatechange = function(_, isAbort) {
        if (isAbort || !script.readyState || /loaded|complete/.test(script.readyState)) {
            script.onload = script.onreadystatechange = null;
            script = undefined;
            if (!isAbort) {
                if (callback) callback();
            }
        }
    };
    script.src = source;
}

if (!window.___skipShowAds) {
  analyticsInit();
}

if (document.getElementsByClassName("facebook-sharer")) {
  document.getElementsByClassName("facebook-sharer").onmousedown = function() {
    updateForSocial( this, 'facebook' );
    return false;
  }
}

if (document.getElementsByClassName("twitter-sharer")) {
  document.getElementsByClassName("twitter-sharer").onmousedown = function() {
    updateForSocial( this, 'twitter' );
    return false;
  }
}

if (document.getElementById("fte-expandable-title")) {
  document.getElementById("fte-expandable-title").onclick = function() {
    if (document.querySelector(".fte-expandable-icon").classList.contains('fte-open')) {
      document.getElementById("entry-comments-content").style.display = "none";
    } else {
      document.getElementById("entry-comments-content").style.display = "block";
      document.getElementById("fb-comments").dataset.width = document.getElementById("fb-comments").parentNode.offsetWidth - 24;
      (function (d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) return;
        js = d.createElement(s);
        js.id = id;
        js.src = "https://connect.facebook.net/en_US/sdk.js#version=v2.6&xfbml=1&appId=797620670264818";
        fjs.parentNode.insertBefore(js, fjs);
      }(document, 'script', 'facebook-jssdk'));
    }
    document.querySelector(".fte-expandable-icon").classList.toggle("fte-open");
  }
}

if (!espn.hasOwnProperty('track')) {
  espn.track = {};
}
if (!espn.track.hasOwnProperty('init')) {
  espn.track.init = function () {
    if (typeof analyticsInit === 'function') {
      analyticsInit();
      window.updateOmnitureData();
    }
  }
}
