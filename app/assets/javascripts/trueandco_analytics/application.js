var userLog = (function(){
    //
    // Private variables
    //
    var defaults = {

            // Available functionality
            clickCount: true,
            clickDetails: true,

            // Action Item
            actionItem: {
                processOnAction: false,
                selector: '',
                event: ''
            },
            processTime: 15,
            processData: function(results, statistics_url){
                console.log(results);
            },
        },
        // End results, what is shown to the user
        results = {
            userReferrer: '',
            time: {
                totalTime: 0,
                timeOnPage: 0,
                timestamp: 0
            },
            clicks: {
                clickCount:0,
                clickDetails: []
            },

        },
        support = !!document.querySelector && !!document.addEventListener,
        data_receiver = '',
        app_token = '',
        settings;

    // Helper Functions
    var helperActions = {

        userReferrer: function (){
            result = document.referrer;
            results.userReferrer = 10;
        },

        /**
         * Detect the X,Y coordinates of the mouse movement
         * @private
         */
        mouseMovement: function(){
            document.addEventListener('mousemove', function(){
                results.mouseMovements.push({
                    timestamp: Date.now(),
                    x: event.pageX,
                    y: event.pageY
                });
            });
        },
    }

    /**
     * Merge defaults with options
     * @private
     * @param {Object} default settings
     * @param {Object} user options
     * @returns {Object} merged object
     */
    function getSettings(defaults, options){
        var option;
        for(option in options){
            if(options.hasOwnProperty(option)){
                defaults[option] = options[option];
            }
        }
        return defaults;
    }

    /**
     * Initialize the event listeners
     * @public
     * @param {Object} user options
     */
    function init(statistics_url, token, options){
        if(!support) return;
        data_receiver = statistics_url;
        app_token = token;

        // Extend default options
        if (options && typeof options === "object") {
            settings = getSettings(defaults, options);
        }

        document.addEventListener('DOMContentLoaded', function() {

            // Countdown Timer
            window.setInterval(function(){
                if(document['visibilityState'] === 'visible'){
                    results.time.timeOnPage++;
                }
                results.time.totalTime++;
                // Check if we need to process results
                if(settings.processTime > 0 && results.time.totalTime % settings.processTime === 0){
                    processResults();
                }
            },1000);
            results.time.timestamp = (function() {
                return Math.round((+new Date())/1000);
            })();

            // Click registration, increment click counter and save click time+position
            if(settings.clickCount || settings.clickDetails){
                document.addEventListener('mouseup', function(){
                    if(settings.clickCount){
                        results.clicks.clickCount++;
                    }
                    if(settings.clickDetails){
                        results.clicks.clickDetails.push({
                            timestamp: Date.now(),
                            node: event.target.outerHTML,
                            x: event.pageX,
                            y: event.pageY
                        });
                    }
                });
            }

            // Mouse movements
            if(settings.mouseMovement){
                helperActions.mouseMovement();
            }

            // referral
            if(settings.userReferrer){
                helperActions.userReferrer();
            }

            // Event Listener to porcess
            if(settings.actionItem.processOnAction){
                var node = document.querySelector(settings.actionItem.selector);
                if(!!!node) throw new Error('Selector was not found.');
                node.addEventListener(settings.actionItem.event, function(){
                    return processResults();
                })
            }
        });
    }

    /**
     * Calls provided function with results as parameter
     * @public
     */
    function processResults(){
        if(settings.hasOwnProperty('processData')){
            var result = settings.processData.call(undefined, results, data_receiver, app_token);
            results.clicks.clickDetails = []
            return result;
        }
        return false;
    }


    // Module pattern, only expose necessary methods
    return {
        init: init,
        processResults: processResults,
    };
})();
