	function GetDate()
    {
        return new Date();
    }

    function AgendaViewModel()
	{
		//Data
		var self = this;

		self.slots =  ko.observable();
		self.speakers =  ko.observable();
		self.sessions =  ko.observable();
		self.selectedSession =  ko.observable();
		self.selectedSpeaker =  ko.observable();
		self.selectedSessionList = ko.observable();

        self.nextSessions = ko.observableArray();
        self.currentSessions = ko.observableArray();

        var today=GetDate();
        var conference = new Date(2012,0,21,8,30,0);
        self.hoursToConference = parseInt((conference-today)/(3600*1000));

		// Operations

        self.goToSpeaker = function(speaker)
        {
            self.selectedSpeaker(speaker);
            $.mobile.changePage("#speakerDetail");
        };

        self.goToSessionList = function(slot)
        {
            var orig = self.sessions();
            var list = ko.utils.arrayFilter(orig, function(value) {
                return value.timeSlot == slot;
            });
            list = _.reject(list, function(value){return value.title==""})
            var obj = new Object();
            obj.name = slot;
            obj.list = ko.observable(list);;
            self.selectedSessionList(obj);
            $.mobile.changePage("#sessions");

        };

        self.goToSession = function(session)
        {
            self.selectedSession(session);
            $.mobile.changePage("#sessionDetail");
        };


		$.getJSON(
			"/speeches.json",
			function (data) {
				self.sessions(ExtractSessions(data));
				self.speakers(ExtractSpeakers(data));
				self.slots(ExtractSlots(data));

                UpdateCurrentSessions(self);
                UpdateNextSessions(self);

                setInterval(function(){
                    UpdateCurrentSessions(self);
                    UpdateNextSessions(self);
                },60000);

			});
	}


	function FixModel(data)
	{
	   return $.each(data,function(index, value){
			if(value.speaker.bio.substring(0, 4) == "http")
				value.speaker.bioUrl=value.speaker.bio;
            else
                 value.speaker.bioUrl="";

            var from = new Date(value.from);
            var to = new Date(value.to);
            from.setFullYear(2012,0,21);
            to.setFullYear(2012,0,21);

           value.from = from;
           value.to = to;

           value.timeSlot=GetShortTime(from) +" - "+GetShortTime(to);
		   if(value.speaker.name=="-")
				value.nolink=true;
           else
                value.nolink=false;
           if(value.hashtag == undefined){
               value.hashtag="";
           }

           this.twitterMessage=ComputeTwitterMessage(this);
           this.twitterUrl=ComputeTwitterUrl(this.twitterMessage);
		});
	}

    function GetShortTime(date){
        var min =  date.getMinutes();
        var minStr = min+"";
        if(min<10)
            minStr="0"+min;
        return date.getHours()-1+":"+minStr;
    }

    function ExtractSessions(data){
        data = FixModel(data);
        return _.sortBy(data, function(value) {return value.timeSlot+value.room});
    }

    function ExtractSlots(data)
    {
        var list = _.pluck(data, "timeSlot");
        list =_.compact(list);
        list = _.sortBy(list, function(num) {return num});
        return _.uniq(list,true);
    }

    function ExtractSpeakers(data)
    {
        var list = _.pluck(data, "speaker");
        list = _.reject(list, function(value) {return value.name  == "-";})
        list = _.sortBy(list, function(value){return value.name});
        return list;
    }

    function UpdateCurrentSessions(model){
        var now=GetDate();
        now.setHours(now.getHours()+1)
        var list = model.sessions();
        list = _.filter(list, function(value){
             return value.from<now && value.to>now && value.title!="";
        });
        model.currentSessions(list);
    }

    function UpdateNextSessions(model){
        var now=GetDate();
        now.setHours(now.getHours()+1);
        var list = model.sessions();
        list = _.filter(list, function(value){
             return value.from>now && value.title!="";
        });
        list = _.groupBy(list, 'timeSlot');
        model.nextSessions(_.toArray(list)[0]);
    }

    function ComputeTwitterMessage(session){
        if(session.hashtag!=undefined){
            if(session.speaker.twitter!="")
                return "Sono a #"+session.hashtag+" by @" + session.speaker.twitter;
            else
                return "Sono a #"+session.hashtag;
        }
    }

    function ComputeTwitterUrl(message){
            return "https://twitter.com/intent/tweet?text="+encodeURIComponent(message+" #uan12");
    }