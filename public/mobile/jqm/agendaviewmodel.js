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



        var today=new Date();
        var conference = new Date(2012,0,21);
        self.daysToConference = parseInt((conference-today)/(24*3600*1000));


		
		// Operations




        self.goToSpeaker = function(speaker)
        {
            self.selectedSpeaker(speaker);
            $.mobile.changePage("#speakerDetail");
        };

        self.goToSessionList = function(slot)
        {
            var orig = self.sessions();
            orig = _.sortBy(orig, function(value) {return value.timeSlot});
            var list = ko.utils.arrayFilter(orig, function(value) {
                return value.timeSlot == slot;
            });
            list = _.sortBy(list, function(value) {return value.room});
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
				data = FixModel(data);
				self.sessions(data);
				self.speakers(ExtractSpeakers(data));
				self.slots(ExtractSlots(data));
			});


	}


	function FixModel(data)
	{
	   return $.each(data,function(index, value){
			if(value.speaker.bio.substring(0, 4) == "http")
				value.speaker.bioUrl=value.speaker.bio;
            else
                 value.speaker.bioUrl="";
			if(value.from == undefined){
				value.from=value["from(4i)"]+":"+value["from(5i)"];
				value.to=value["to(4i)"]+":"+value["to(5i)"];
			}
			else {
				var from = new Date(value.from);
				var to = new Date(value.to);
				var fromMin =  from.getMinutes();
				var toMin =  to.getMinutes();
				var toMinStr = toMin+"";
				var fromMinStr = fromMin+"";
				if(toMin<10)
						toMinStr="0"+ toMin;
				if(fromMin<10)
						fromMinStr="0"+ fromMin;
				value.from = from.getHours()-1+":"+fromMinStr;
				value.to = to.getHours()-1+":"+toMinStr;
			}
           value.timeSlot=value.from +" - "+value.to;
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