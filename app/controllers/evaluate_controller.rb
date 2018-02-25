class EvaluateController < ApplicationController
  require 'date'

  def eval_SL
    @flag = 0
    @error = []
    @output = ""

    @w_pay = "SLWOP"

    if(params[:paidInp_0] != nil) #si paidInp_0 ay name ng <input>. see evaluation.html.erb line 132, so yeah similar lang din sa iba.
      @w_pay = "SLWP"
      if(params[:rank] != nil)
        if(params[:rank].to_i <= 2)
          @flag = 0
        end
      else
        @flag = 0
      end
    end

    @loc_ab = "local"
    if(params[:areaInp_0] != nil)
      @loc_ab = params[:areaInp_0]
    end

    @rank = 0
    if(params[:rank] != nil)
      @rank = params[:rank].to_i
    end

    @service = 0
    if(params[:servYear] != nil)
      @service = params[:servYear].to_i
    end

    @subs = "Y"
    if(params[:subs] != nil)
      @subs = params[:subs]
    end

    @tenure = "N"
    if(params[:tenured] != nil)
      @tenure = params[:tenured]
    end

    @age = 0
    if(params[:birthday] != nil)
      @birthdate = Date.strptime(params[:birthday], "%m/%d/%Y")
      @age = Date.today.year - @birthdate.year
      @temp = Date.new(@birthdate.year + @age, @birthdate.month, @birthdate.day)
      if ((Date.today <=> @temp) == -1)
        @age = @age - 1
      end
    end

    if ((@rank > 2) and (@service >= 1) and (@subs == "N") and (@tenure == "Y") and (@age <= 40))
      @flag = 1
    else
      if (@rank <= 2)
        @error.push("Must be a Faculty/Associate Prof. below.")
      end
      if (@service < 1)
        @error.push("Service must be at least 1 yr.")
      end
      if (@subs == "Y")
        @error.push("Must not be a substitute teacher.")
      end
      if (@tenure == "N")
        @error.push("Must be tenured.")
      end
      if (@age > 40)
        @error.push("Age has exceeded 40.")
      end
    end

    if (@flag == 1)
      @output = "<div class='ui message positive'>
                  <div class='header'>You are qualified!</div>
                </div>";  
    else
      @output = "<div class='ui message negative'>
                <div class='header'>You are not qualified</div>
                <p>Here's why:</p><ul>";
                @error.each { |val|
                  @output = @output + "<li>#{val}</li>";
                }
      @output = @output + "</ul></div>";

    end

    render action: 'evaluation'

  end

  def eval_DSF
    @flag = 0
    @error = []
    @output = ""

    @w_pay = "SDWOP"

    if(params[:paidInp_0] != nil) 
      @w_pay = "SDWP"
    else
      @w_pay = "SDWOP"
    end

    @loc_ab = "local"
    if(params[:areaInp_0] != nil)
      @loc_ab = params[:areaInp_0]
    end

    @rank = 0
    if(params[:rank] != nil)
      @rank = params[:rank].to_i
    end

    @service = 0
    if(params[:servYear] != nil)
      @service = params[:servYear].to_i
    end

    @subs = "Y"
    if(params[:subs] != nil)
      @subs = params[:subs]
    end

    @tenure = "N"
    if(params[:tenured] != nil)
      @tenure = params[:tenured]
    end

    @age = 0
    if(params[:birthday] != nil)
      @birthdate = Date.strptime(params[:birthday], "%m/%d/%Y")
      @age = Date.today.year - @birthdate.year
      @temp = Date.new(@birthdate.year + @age, @birthdate.month, @birthdate.day)
      if ((Date.today <=> @temp) == -1)
        @age = @age - 1
      end
    end

    if ((@rank > 2) and (@service >= 1) and (@subs == "N") and (@tenure == "Y") and (@age <= 40))
      @flag = 1
    else
      if (@rank <= 2)
        @error.push("Must be a Faculty/Associate Prof. below.")
      end
      if (@service < 1)
        @error.push("Service must be at least 1 yr.")
      end
      if (@subs == "Y")
        @error.push("Must not be a substitute teacher.")
      end
      if (@tenure == "N")
        @error.push("Must be tenured.")
      end
      if (@age > 40)
        @error.push("Age has exceeded 40.")
      end
    end

    if (@flag == 1)
      @output = "<div class='ui message positive'>
                  <div class='header'>You are qualified!</div>
                </div>";  
    else
      @output = "<div class='ui message negative'>
                <div class='header'>You are not qualified</div>
                <p>Here's why:</p><ul>";
                @error.each { |val|
                  @output = @output + "<li>#{val}</li>";
                }
      @output = @output + "</ul></div>";
    end

    render action: 'evaluation'

  end

  def eval_Sab
    @flag = 0
    @output = ""
    @error = []

    @service = 0
    if(params[:servYear] != nil)
      @service = params[:servYear].to_i
    end

    @eff = 0
    if ((params[:effectStart] != nil) or (params[:effectEnd] != nil))
      @startDate = Date.strptime(params[:effectStart], "%m/%d/%Y")
      @endDate = Date.strptime(params[:effectEnd], "%m/%d/%Y")

      @eff = (@endDate - @startDate).to_i

      # can be a more accurate/elegant computation 
      if (@eff <= 365)
        @eff = 1
      else
        @eff = 2
      end
    end 

    @age = 0
    if(params[:birthday] != nil)
      @birthdate = Date.strptime(params[:birthday], "%m/%d/%Y")
      @age = Date.today.year - @birthdate.year
      @temp = Date.new(@birthdate.year + @age, @birthdate.month, @birthdate.day)
      if ((Date.today <=> @temp) == -1)
        @age = @age - 1
      end
    end

    if ((@eff <= 1) and (@service >= 6) and (@age < 63))
      @flag = 1
    else
      if (@eff > 1)
        @error.push("Effectivity must be within 1 year.")
      end
      if (@service < 6)
        @error.push("Service must be at least 6 years.")
      end
      if (@age >= 63)
        @error.push("Age must be younger than 63 years old.")
      end
    end

    if (@flag == 1)
      @output = "<div class='ui message positive'>
                  <div class='header'>You are qualified!</div>
                </div>";  

    else
      @output = "<div class='ui message negative'>
                <div class='header'>You are not qualified</div>
                <p>Here's why:</p><ul>";
                @error.each { |val|
                  @output = @output + "<li>#{val}</li>";
                }
      @output = @output + "</ul></div>";
    end

    render action: 'evaluation'

  end

  def eval_SD
    @flag = 0
    @w_pay = "SLWP"
    @output = ""
    @error = []

    if(params[:paidInp_0] != nil) 
      @w_pay = "SLWP"
    else
      @w_pay = "SLWOP"
    end

    # start date 
    # end date
    # both undefined at start?

    @startDate = Date.strptime(params[:schedStart], "%m/%d/%Y")
    if (params[:schedStart] != nil)
      @startDate = params[:schedStart]
    end

    @endDate = Date.strptime(params[:schedEnd], "%m/%d/%Y")
    if (params[:schedEnd] != nil)
      @endDate = params[:schedEnd]
    end

    @loc_ab = "local"
    if(params[:areaInp_0] != nil)
      @loc_ab = params[:areaInp_0]
    end

    @abs = 0
    if (params[:missed] != nil)
      @abs = params[:missed].to_i
    end

    if(@abs <= 20)
      @flag = 1
    else
      if (@abs > 20)
        @error.push("Exceeded maximum number of absences (20).")
      end
    end

    if (@flag == 1)
      @output = "<div class='ui message positive'>
                  <div class='header'>You are qualified!</div>
                </div>";  
    else
      @output = "<div class='ui message negative'>
                <div class='header'>You are not qualified</div>
                <p>Here's why:</p><ul>";
                @error.each { |val|
                  @output = @output + "<li>#{val}</li>";
                }
      @output = @output + "</ul></div>";
    end

    render action: 'evaluation'

  end


  def eval_EP
    @flag = 0
    @output = ""
    @error = []

    @full_time = 0
    if(params[:fulltime] != nil)
      @full_time = 1
    end

    @loc_ab = "local"
    if(params[:areaInp_0] != nil)
      @loc_ab = params[:areaInp_0]
    end

    @emptype = ""
    if(params[:emptype] != nil)
      @emptype = params[:emptype]
    end

    @units_t = 0
    if(params[:teachunits] != nil)
      @units_t = params[:teachunits].to_i
    end

    @units_s = 0
    if(params[:studyunits] != nil)
      @units_s = params[:studyunits].to_i
    end

    if((@units_t + @units_s <= 18) and (@full_time == 1))
      @flag = 1
    else
      if (@units_t + @units_s > 18)
        @error.push("Exceeded maximum number of units (18).")
      end
      @error.push("Must be full-time.")
    end


    if (@flag == 1)
      @output = "<div class='ui message positive'>
                  <div class='header'>You are qualified!</div>
                </div>";  
    else
      @output = "<div class='ui message negative'>
                <div class='header'>You are not qualified</div>
                <p>Here's why:</p><ul>";
                @error.each { |val|
                  @output = @output + "<li>#{val}</li>";
                }
      @output = @output + "</ul></div>";
    end


    render action: 'evaluation'
  end

  def show
  end
end
