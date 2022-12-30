class ThaaliTakhmeensController < ApplicationController
    before_action :set_thaali_takhmeen, only: [:show, :edit, :update, :destroy]
    before_action :check_for_current_year_takhmeen, only: [:new]

    def index
        @q = ThaaliTakhmeen.in_the_year($CURRENT_YEAR_TAKHMEEN).ransack(params[:q])
        @thaalis = @q.result(distinct: true).order(number: :ASC)
    end

    def new
        prev_takhmeen = @sabeel.thaali_takhmeens.where(year: $PREV_YEAR_TAKHMEEN).first

        if prev_takhmeen.nil?
            @thaali_takhmeen = @sabeel.thaali_takhmeens.new
        else
            prev_takhmeen = prev_takhmeen.slice(:number, :size)
            @thaali_takhmeen = @sabeel.thaali_takhmeens.new
            @thaali_takhmeen.number = prev_takhmeen[:number]
            @thaali_takhmeen.size = prev_takhmeen[:size]
        end
    end

    def create
        @sabeel = Sabeel.find(params[:sabeel_id])
        @thaali_takhmeen = @sabeel.thaali_takhmeens.new(thaali_takhmeen_params)
        @thaali_takhmeen.year = $CURRENT_YEAR_TAKHMEEN

        if @thaali_takhmeen.valid?
            @thaali_takhmeen.save
            redirect_to takhmeen_path(@thaali_takhmeen), success: "Thaali Takhmeen created successfully"
        else
            render :new
        end
    end

    def show
        @transactions = @thaali_takhmeen.transactions
        @sabeel = @thaali_takhmeen.sabeel
    end

    def edit
    end

    def update
        if @thaali_takhmeen.update(thaali_takhmeen_params)
            redirect_to takhmeen_path(@thaali_takhmeen), success: "Thaali Takhmeen updated successfully"
        else
            render :edit
        end
    end

    def destroy
        @thaali_takhmeen.destroy
        redirect_to sabeel_path(@thaali_takhmeen.sabeel), success: "Thaali Takhmeen destroyed successfully"
    end

    private

        def thaali_takhmeen_params
            params.require(:thaali_takhmeen).permit(:number, :size, :total)
        end

        def set_thaali_takhmeen
            @thaali_takhmeen = ThaaliTakhmeen.find(params[:id])
        end

        def check_for_current_year_takhmeen
            @sabeel = Sabeel.find(params[:sabeel_id])
            @cur_takhmeen = @sabeel.thaali_takhmeens.where(year: $CURRENT_YEAR_TAKHMEEN).first

            unless @cur_takhmeen.nil?
                message = "Takhmeen has already been done for the Sabeel with ITS No: #{@sabeel.its} for the year: #{$CURRENT_YEAR_TAKHMEEN}"
                redirect_back fallback_location: sabeel_path(@sabeel), notice: message
            end
        end
end
