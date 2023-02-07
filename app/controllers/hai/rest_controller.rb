module Hai
  class RestController < ::ApplicationController
    skip_forgery_protection
    def index
      render json:
               Hai::Read
                 .new(model_class, context)
                 .list(
                   # TODO: this is a security risk, thanks co-pilot
                   # potenntial use attributes types plus AREL_TYPE_CAST
                   filter: params[:filter]&.to_unsafe_h,
                   limit: params[:limit],
                   offset: params[:offset],
                   sort: params[:sort]&.to_unsafe_h
                 )
                 .to_json
    end

    def show
      render json:
               Hai::Read
                 .new(model_class, context)
                 .read(id: { eq: params[:id] })
                 .to_json
    end

    def create
      render json:
               Hai::Create
                 .new(model_class, context)
                 .execute(**params[params[:model].singularize].permit!)
                 .to_json
    end

    def update
      render json:
               Hai::Update
                 .new(model_class, context)
                 .execute(
                   id: params[:id],
                   attributes: params[params[:model]].permit!
                 )
                 .to_json
    end

    def destroy
      render json:
               Hai::Delete
                 .new(model_class, context)
                 .execute(id: params[:id])
                 .to_json
    end

    private

    def context
      try(:super) || {}
    end

    def model_class
      params[:model].classify.constantize
    end

    def read_params
      params.permit! || {}
      # params.permit(:limit, :offset, sort: { :field , :order},filter: {} )
    end
  end
end
