Spree::Admin::ReportsController.class_eval do
  before_filter :add_own
  #before_filter :basic_report_setup, :actions => [:profit, :revenue, :units, :top_products, :top_customers, :geo_revenue, :geo_units, :count]

  def add_own
    a = Spree::User.class
    return if Spree::Admin::ReportsController.available_reports.has_key?(:missing_carts)
    Spree::Admin::ReportsController.available_reports.merge!(:missing_carts => {:name => "Missing Carts Total", :description => "Missing Carts Total Report"})
  end
  #I18n.locale = Rails.application.config.i18n.default_locale
  #I18n.reload!

  #ADVANCED_REPORTS ||= {}
  #[ :revenue, :units, :profit, :count, :top_products, :top_customers, :geo_revenue, :geo_units, :geo_profit].each do |x|
  #  ADVANCED_REPORTS[x]= {name: I18n.t("adv_report."+x.to_s), :description => I18n.t("adv_report."+x.to_s)}
  #end

  def missing_carts
      params[:q] = {} unless params[:q]

      if params[:q][:created_at_gt].blank?
        params[:q][:created_at_gt] = Time.zone.now.beginning_of_month
      else
        params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue Time.zone.now.beginning_of_month
      end

      if params[:q] && !params[:q][:created_at_lt].blank?
        params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
      end

      params[:q][:s] ||= "created_at desc"

      @search = Spree::Order.incomplete.ransack(params[:q])

      @missing_orders = @search.result
      @total_missing_orders = @search.result.count
      @total = @missing_orders.map(&:total).sum.to_s
  end


end