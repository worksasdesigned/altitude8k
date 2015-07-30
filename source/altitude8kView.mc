using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;


// AWI 21.07.2015
// shows all 14 8.000+m Montains + Montainline
// shows 12& 24h mode + date
// shows movebar & steps
// bluetooth indicator
// second as circle

class altitude8kView extends Ui.WatchFace {

var pic_back;
var device_settings;
    // This ARRAY comes from SectorWatch Project (GitHub) Thx!
    const min_array = [ [109,   0], [120,   1], [132,   2], [143,   5], [153,   9],
                         [164,  15], [173,  21], [182,  28], [190,  36], [197,  45],
                         [203,  55], [209,  65], [213,  75], [216,  86], [217,  98],
                         [218, 109], [217, 120], [216, 132], [213, 143], [209, 153],
                         [203, 164], [197, 173], [190, 182], [182, 190], [173, 197],
                         [164, 203], [153, 209], [143, 213], [132, 216], [120, 217],
                         [109, 218], [ 98, 217], [ 86, 216], [ 75, 213], [ 65, 209],
                         [ 55, 203], [ 45, 197], [ 36, 190], [ 28, 182], [ 21, 173],
                         [ 15, 164], [  9, 153], [  5, 143], [  2, 132], [  1, 120],
                         [  0, 109], [  1,  98], [  2,  86], [  5,  75], [  9,  65],
                         [ 15,  55], [ 21,  45], [ 28,  36], [ 36,  28], [ 45,  21],
                         [ 55,  15], [ 65,   9], [ 75,   5], [ 86,   2], [ 98,   1] ];
    var fast_updates = true;
    var activproz;
    var activ_alt = null;    
    var moveBarLevel= 0;
    var pic_bt, pic_nobt;
    //! Load your resources here
    function onLayout(dc) {
	    device_settings = Sys.getDeviceSettings(); 
	    //pic_bt         = Ui.loadResource(Rez.Drawables.id_bt); 
	    //pic_nobt       = Ui.loadResource(Rez.Drawables.id_nobt);  
    } 
    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
      // black is beautiful CLEAR the screen.
      dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
      dc.clear();  

 
        // Uhrzeit & datum auselsen    
        var clockTime = Sys.getClockTime();
        var dateStrings = Time.Gregorian.info( Time.now(), Time.FORMAT_MEDIUM);
        
        var hour, min, time, day;
        
        day = dateStrings.day;
        min  = clockTime.min;
        hour = clockTime.hour;
        
         // BERG oder KAMMLINIE ZEICHNEN #############################################################################################################     
        pic_back = null;// FREE MEMORY    
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
         
		         if ( (day == 1 ) || (day == 15) ){  // everest
                        pic_back     = Ui.loadResource(Rez.Drawables.id_everestline);
                        dc.drawBitmap(1, 42, pic_back); // Berg zeichnen    
                    if (fast_updates){
                        dc.drawLine(85,42, 119,42);
                        dc.drawText(84, 35 , Gfx.FONT_XTINY, "#1 8850m" , Gfx.TEXT_JUSTIFY_RIGHT );
                        dc.drawText(dc.getWidth()/2, 12, Gfx.FONT_MEDIUM, "Mt.Everest", Gfx.TEXT_JUSTIFY_CENTER);
                     }  	
		        } else if ( (day == 2 ) || (day == 16) ) { // dhaulagiri
                        pic_back     = Ui.loadResource(Rez.Drawables.id_dhaulagiriline);
                        dc.drawBitmap(1, 37, pic_back); // Berg zeichnen        
                    if (fast_updates){
		        	    dc.drawLine(90,40, 110,40);
		                dc.drawText(89, 36 , Gfx.FONT_XTINY, "#7 8167m" , Gfx.TEXT_JUSTIFY_RIGHT );
		                dc.drawText(dc.getWidth()/2, 10, Gfx.FONT_MEDIUM, "Dhaulagiri", Gfx.TEXT_JUSTIFY_CENTER); 
                    }
		          } else if ( (day == 3 ) || (day == 17) ) { // Chooyu
	               	    pic_back     = Ui.loadResource(Rez.Drawables.id_chooyuline);
                        dc.drawBitmap(1, 44, pic_back); // Berg zeichnen    
		        	if (fast_updates){
		        	    dc.drawLine(81,44, 120,44);
		                dc.drawText(121, 37 , Gfx.FONT_XTINY, "#6 8201m" , Gfx.TEXT_JUSTIFY_LEFT );
		                dc.drawText(dc.getWidth()/2, 10, Gfx.FONT_MEDIUM, "Cho Oyu", Gfx.TEXT_JUSTIFY_CENTER); 
                    }
		         } else if ( (day == 4 ) || (day == 18) ) { // k2
		        	    pic_back     = Ui.loadResource(Rez.Drawables.id_k2westline);
                        dc.drawBitmap(1, 35, pic_back); // Berg zeichnen    
                       	if (fast_updates){
			        	    dc.drawLine(104,44, 127,35);
			                dc.drawLine(85,44, 104,44);
			                dc.drawText(84, 37 , Gfx.FONT_XTINY, "#2 8611m" , Gfx.TEXT_JUSTIFY_RIGHT );
			                dc.drawText(dc.getWidth()/2, 10, Gfx.FONT_MEDIUM, "K2", Gfx.TEXT_JUSTIFY_CENTER);
                        }
		         } else if ( (day == 5 ) || (day == 19) || (day == 29) ) { // Kangenchunga
		        	   pic_back     = Ui.loadResource(Rez.Drawables.id_kangenline);
                        dc.drawBitmap(1, 40, pic_back); // Berg zeichnen    
                     	if (fast_updates){
			        	    dc.drawLine(94,40, 110,48);
			                dc.drawLine(110,48, 130,48);    
			                dc.drawText(131, 40 , Gfx.FONT_XTINY, "#3 8586m" , Gfx.TEXT_JUSTIFY_LEFT );
			                dc.drawText(dc.getWidth()/2, 14, Gfx.FONT_MEDIUM, "Kangchenjunga", Gfx.TEXT_JUSTIFY_CENTER);  
	                    }
		         } else if ( (day == 6 ) || (day == 20) ) { // lothse
		         	
                      pic_back     = Ui.loadResource(Rez.Drawables.id_lothseline);
                      dc.drawBitmap(1, 44, pic_back); // Berg zeichnen
		         	if (fast_updates){
		              dc.drawLine(81,44, 120,44);
		              dc.drawText(121, 37 , Gfx.FONT_XTINY, "#4 8501m" , Gfx.TEXT_JUSTIFY_LEFT );
		              dc.drawText(dc.getWidth()/2, 10, Gfx.FONT_MEDIUM, "Lothse", Gfx.TEXT_JUSTIFY_CENTER); 
                    }
		         } else if ( (day == 7 ) || (day == 21) ) { // makalu
	                    pic_back = Ui.loadResource(Rez.Drawables.id_makaluline);
                        dc.drawBitmap(1, 54, pic_back); // Berg zeichnen
		         	if (fast_updates){
		              dc.drawLine(90,54, 120,54);
		              dc.drawText(121, 47 , Gfx.FONT_XTINY, "#5 8462m" , Gfx.TEXT_JUSTIFY_LEFT );
		              dc.drawText(dc.getWidth()/2, 10, Gfx.FONT_MEDIUM, "Makalu", Gfx.TEXT_JUSTIFY_CENTER); 
                    }
		         } else if ( (day == 8 ) || (day == 22) || (day == 30) ) { // manaslu
		         	pic_back     = Ui.loadResource(Rez.Drawables.id_manasluline);
                    dc.drawBitmap(1, 30, pic_back); // Berg zeichnen
		         	if (fast_updates){
		         	    dc.drawLine(130,40, 144,30);
		                dc.drawLine(130,40, 120,40);    
		                dc.drawText(119, 32 , Gfx.FONT_XTINY, "#8 8163m" , Gfx.TEXT_JUSTIFY_RIGHT );
		                dc.drawText(dc.getWidth()/2, 7, Gfx.FONT_MEDIUM, "Manaslu", Gfx.TEXT_JUSTIFY_CENTER); 
                    }
		        } else if ( (day == 9 ) || (day == 23) ) { // Nanga
		              pic_back     = Ui.loadResource(Rez.Drawables.id_nangaline);
                      dc.drawBitmap(1, 54, pic_back); // Berg zeichnen 
                      
		            if (fast_updates){
		                dc.drawLine(90,54, 120,54);
		                dc.drawText(89, 47 , Gfx.FONT_XTINY, "#9 8126m" , Gfx.TEXT_JUSTIFY_RIGHT );
		                dc.drawText(dc.getWidth()/2, 10, Gfx.FONT_MEDIUM, "Nanga Parbat", Gfx.TEXT_JUSTIFY_CENTER);
		                dc.drawText(dc.getWidth()/2, 31 , Gfx.FONT_XTINY, "Schicksalsberg" , Gfx.TEXT_JUSTIFY_CENTER );   
                    }  
		        } else if ( (day == 10 ) || (day == 24) || (day == 31)) { // Annapurna
		            pic_back     = Ui.loadResource(Rez.Drawables.id_annapurnaline);
                    dc.drawBitmap(1, 36, pic_back); // Berg zeichnen
		            if (fast_updates){      
		                dc.drawLine(87,54, 100,36);
		                dc.drawLine(87,54, 85,54);
		                dc.drawLine(100,36, 110,36);
		                dc.drawText(84, 47 , Gfx.FONT_XTINY, "#10 8078m" , Gfx.TEXT_JUSTIFY_RIGHT );
		                dc.drawText(dc.getWidth()/2, 10, Gfx.FONT_MEDIUM, "Annapurna", Gfx.TEXT_JUSTIFY_CENTER);  
                    }  
		        } else if ( (day == 11 ) || (day == 25) ) { // broad Peak
		                pic_back     = Ui.loadResource(Rez.Drawables.id_broadpeakline);
                        dc.drawBitmap(1, 52, pic_back); // Berg zeichnen
		            if (fast_updates){
		                dc.drawLine(90,52, 120,52);
		                dc.drawText(87, 45 , Gfx.FONT_XTINY, "#12 8047m" , Gfx.TEXT_JUSTIFY_RIGHT );
		                dc.drawText(dc.getWidth()/2, 10, Gfx.FONT_MEDIUM, "Broad Peak", Gfx.TEXT_JUSTIFY_CENTER);
                    }  
		        } else if ( (day == 12 ) || (day == 26) ) { // Brum1
		              pic_back     = Ui.loadResource(Rez.Drawables.id_brum1line);
                      dc.drawBitmap(1, 46, pic_back); // Berg zeichnen
		            if (fast_updates){
		                dc.drawLine(130,46, 109,46);
		                dc.drawText(131, 40 , Gfx.FONT_XTINY, "#11 8068m" , Gfx.TEXT_JUSTIFY_LEFT );
		                dc.drawText(dc.getWidth()/2, 10, Gfx.FONT_MEDIUM, "Gasherbrum I", Gfx.TEXT_JUSTIFY_CENTER);  
                    }  
		        } else if ( (day == 13 ) || (day == 27) ) { // brum 2
		            pic_back     = Ui.loadResource(Rez.Drawables.id_brum2line);
                    dc.drawBitmap(1, 48, pic_back); // Berg zeichnen
		            if (fast_updates){ 
		              dc.drawLine(155,48, 120,48);
		              dc.drawText(119, 42 , Gfx.FONT_XTINY, "#13 8035m" , Gfx.TEXT_JUSTIFY_RIGHT );
		              dc.drawText(dc.getWidth()/2, 13, Gfx.FONT_MEDIUM, "Gasherbrum II", Gfx.TEXT_JUSTIFY_CENTER);   
                    }  
		         } else if ( (day == 14 ) || (day == 28) ) { //shisha
		             pic_back     = Ui.loadResource(Rez.Drawables.id_shishaline);
                     dc.drawBitmap(1, 48, pic_back); // Berg zeichnen
		            if (fast_updates){
                       dc.drawLine(90,48, 123,48);
                       dc.drawText(89, 42 , Gfx.FONT_XTINY, "#14 8013m" , Gfx.TEXT_JUSTIFY_RIGHT );
                       dc.drawText(dc.getWidth()/2, 15, Gfx.FONT_MEDIUM, "Shisha Pangma", Gfx.TEXT_JUSTIFY_CENTER);
                    }
		       }else {
		            pic_back     = Ui.loadResource(Rez.Drawables.id_everestline);
                    dc.drawBitmap(1, 42, pic_back); // Berg zeichnen  
		         	if (fast_updates){
		         	    dc.drawLine(85,42, 119,42);
		                dc.drawText(84, 35 , Gfx.FONT_XTINY, "#1 8850m" , Gfx.TEXT_JUSTIFY_RIGHT );
		                dc.drawText(dc.getWidth()/2, 12, Gfx.FONT_MEDIUM, "Mt.Everest", Gfx.TEXT_JUSTIFY_CENTER);      
                    }
		        }

        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        if( !device_settings.is24Hour ) { // AM/PM anzeige
           if (hour >= 12) {
                hour = hour - 12;
                dc.drawText(70, dc.getHeight()/2 , Gfx.FONT_SMALL , "pm" , Gfx.TEXT_JUSTIFY_RIGHT );
			    dc.drawText(71, dc.getHeight()/2 , Gfx.FONT_SMALL , "pm" , Gfx.TEXT_JUSTIFY_RIGHT );
			    
			    }
		    else{  
			    dc.drawText(70, dc.getHeight()/2, Gfx.FONT_SMALL , "am" , Gfx.TEXT_JUSTIFY_RIGHT );
				dc.drawText(71, dc.getHeight()/2, Gfx.FONT_SMALL , "am" , Gfx.TEXT_JUSTIFY_RIGHT );
			}
            if (hour == 0) {hour = 12;}    
            hour  = Lang.format("$1$",[hour.format("%2d")]);
            min   = Lang.format("$1$",[min.format("%02d")]); 
        }
        else {            
            hour  = Lang.format("$1$",[hour.format("%02d")]);
            min   = Lang.format("$1$",[min.format("%02d")]);
        }
      
        // #########################draw TIME ####################################
        var einer = 0; 
        if (hour.toNumber == 1) {einer = 10;}      
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        dc.drawText(92 - einer, 40 , Gfx.FONT_NUMBER_THAI_HOT , hour.toString(), Gfx.TEXT_JUSTIFY_CENTER );
        dc.drawText(90 - einer, 40 , Gfx.FONT_NUMBER_THAI_HOT , hour.toString(), Gfx.TEXT_JUSTIFY_CENTER );
        dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_TRANSPARENT);
        dc.drawText(90 + dc.getTextWidthInPixels(hour.toString(), Gfx.FONT_NUMBER_THAI_HOT) -1 , 68 , Gfx.FONT_NUMBER_HOT , min.toString(), Gfx.TEXT_JUSTIFY_CENTER );
        
        //get date & display
       
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
        var datum_print;
        if( !device_settings.is24Hour ){ //MONAT Tag oder TAG  Monat
            datum_print =    dateStrings.month.toString() + " " + dateStrings.day.toString();
        } else {
            datum_print =   dateStrings.day.toString() + " " + dateStrings.month.toString();             
        }     
        
        dc.drawText(dc.getWidth()/2, 195, Gfx.FONT_XTINY, datum_print, Gfx.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() /2, 170 , Gfx.FONT_MEDIUM, dateStrings.day_of_week.toString(), Gfx.TEXT_JUSTIFY_CENTER); 

      
       if( fast_updates ) {   // #########################################################################################SEKUNDENANZEIGE####################################################################################
               // bluetooth
               // if( device_settings.phoneConnected == true){ // bluetooth connected?
               //  dc.drawBitmap(135, 155, pic_bt);
               // } else {
               //  dc.drawBitmap(135, 155, pic_nobt);
               // }   
                        
           // Nochmal das Datum und Uhrzeit schreiben bei fast_updates
	            var dateInfo = Time.Gregorian.info( Time.now(), Time.FORMAT_SHORT );
               //Sekunde
               var sec = dateInfo.sec;
                dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT); // Grause Sekunden
			    dc.drawText(90 + dc.getTextWidthInPixels(hour.toString(), Gfx.FONT_NUMBER_THAI_HOT) + dc.getTextWidthInPixels(min.toString(), Gfx.FONT_NUMBER_HOT) -21 , 86 , Gfx.FONT_NUMBER_MEDIUM , Lang.format("$1$",[sec.format("%02d")]), Gfx.TEXT_JUSTIFY_LEFT);
        
	            
               // Sekundenpunkt
               if  ( sec <= 12 ){
                    dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_YELLOW); // Sonne
                } else if ( sec <= 18 ){
                    dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_ORANGE); // Sonnenuntergang   
                } else if (sec <= 42 ) { 
                    dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_DK_GRAY); // Mond
                } else if (sec <= 47 ) {
                    dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_ORANGE); // Sonnenaufgang
                 } else {
                     dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_YELLOW); // Sonne
               }               
               dc.fillCircle(min_array[dateInfo.sec][0],min_array[dateInfo.sec][1],13);
             
             if  ( sec <= 12 ){
                    dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_RED); // Sonne
                } else if ( sec <= 18 ){
                    dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_DK_RED); // Sonnenuntergang   
                } else if (sec <= 42 ) { 
                    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE); // Mond
                } else if (sec <= 47 ) {
                    dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_DK_RED); // Sonnenaufgang
                 } else {
                     dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_RED); // Sonne
               }
               
               dc.drawCircle(min_array[dateInfo.sec][0],min_array[dateInfo.sec][1],14);
               dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
              
               
                // Batterie
               var batt = Sys.getSystemStats().battery;
               batt = batt.toNumber();  
               dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_WHITE); 
               dc.fillRectangle(155, 144, 20, 10); // weißer Bereich
               if (batt >= 50){dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_DK_GRAY);}
               dc.fillRectangle(174, 146, 3, 5); // bobbel
               dc.drawRectangle(155, 144, 20, 10); // rahmen
               if (batt >= 50){dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_GREEN);}
               else if (batt >= 25) {dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_ORANGE);}
               else {dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_RED);}  
               dc.fillRectangle(156, 145, (batt.toNumber() / 5 - 1),8); // Batterie Bar
               dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
               batt = batt.toString() + "%";
               dc.drawText(195,137 , Gfx.FONT_XTINY, batt , Gfx.TEXT_JUSTIFY_CENTER );
 
               // Show steps
               // Show steps and stepsGoal als numbers
                var activity = ActivityMonitor.getInfo();
                moveBarLevel = activity.moveBarLevel;
                var stepsGoal = activity.stepGoal;
                var stepsLive = activity.steps; 
                var activproz = stepsLive / stepsGoal.toFloat();
                dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
               // Steps Prozent
                activproz = activproz.toNumber();
                activproz = activproz.toString() + "%";   
               // dc.drawText(dc.getWidth()/2,  13 , Gfx.FONT_XTINY, activproz , Gfx.TEXT_JUSTIFY_CENTER );
               
                dc.drawText(13,143  , Gfx.FONT_XTINY,"Steps:" , Gfx.TEXT_JUSTIFY_LEFT);
                dc.drawText(20, 158 , Gfx.FONT_XTINY, "Goal:" , Gfx.TEXT_JUSTIFY_LEFT);
                dc.drawText(57,143  , Gfx.FONT_XTINY,stepsLive.toString() , Gfx.TEXT_JUSTIFY_LEFT);
                dc.drawText(57, 158 , Gfx.FONT_XTINY, stepsGoal.toString() , Gfx.TEXT_JUSTIFY_LEFT);
                
                // Movementbar als Lawinen-Schild


               
               if (moveBarLevel >=5) {                
                    dc.setColor( Gfx.COLOR_DK_RED, Gfx.COLOR_DK_RED);
                    dc.fillRoundedRectangle(156, 160, 22, 22, 3);
                    dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(167,155  , Gfx.FONT_MEDIUM, "5" , Gfx.TEXT_JUSTIFY_CENTER);
                    
                }else if (moveBarLevel >=4) {
                
                    dc.setColor( Gfx.COLOR_RED, Gfx.COLOR_RED);
                    dc.fillRoundedRectangle(156, 160, 22, 22, 3);
                    dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(167,155  , Gfx.FONT_MEDIUM, "4" , Gfx.TEXT_JUSTIFY_CENTER);
                }else if (moveBarLevel >=3) {
                
                    dc.setColor( Gfx.COLOR_ORANGE, Gfx.COLOR_ORANGE);
                    dc.fillRoundedRectangle(156, 160, 22, 22, 3);
                    dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(167,155  , Gfx.FONT_MEDIUM, "3" , Gfx.TEXT_JUSTIFY_CENTER);    
                }else if (moveBarLevel >=2) {
                
                    dc.setColor( Gfx.COLOR_YELLOW, Gfx.COLOR_YELLOW);
                    dc.fillRoundedRectangle(156, 160, 22, 22, 3);
                    dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(167,155  , Gfx.FONT_MEDIUM, "2" , Gfx.TEXT_JUSTIFY_CENTER);
                }else if (moveBarLevel >=1) {
                    dc.setColor( Gfx.COLOR_GREEN, Gfx.COLOR_GREEN);
                    dc.fillRoundedRectangle(156, 160, 22, 22, 3);
                    dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
                    dc.drawText(167,155  , Gfx.FONT_MEDIUM, "1" , Gfx.TEXT_JUSTIFY_CENTER); 
                 }  
        } // Ende fast updates


// #########################################################################################################HÖHE
      
        

    } // ENDE ON UPDATE
    


    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
            fast_updates = true;
            Ui.requestUpdate();
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
            fast_updates = false;
            Ui.requestUpdate();
    }

}
  