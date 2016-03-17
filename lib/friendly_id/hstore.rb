require "friendly_id/hstore/version"

module FriendlyId
  module Hstore
    class << self

      def setup(model_class)
        model_class.friendly_id_config.use :slugged
      end

      def included(model_class)
        advise_against_untranslated_model(model_class)
      end

      def advise_against_untranslated_model(model)
        field = model.friendly_id_config.query_field
        unless model.respond_to?('translated_attrs') ||
               model.translated_attrs.exclude?(field.to_sym)
          raise "[FriendlyId] You need to translate the '#{field}' field with " \
            "hstore_translates (add 'translates :#{field}' in your model '#{model.name}')"
        end
      end

      private :advise_against_untranslated_model
    end

    def set_friendly_id(text, locale = nil)
      execute_with_locale(locale || ::I18n.locale) do
        set_slug normalize_friendly_id(text)
      end
    end

    def should_generate_new_friendly_id?
      translations = get_field_translations_hash
      return (translations.blank? || [::I18n.locale.to_s].blank?)
    end

    def set_slug(normalized_slug = nil)
      translations = get_field_translations_hash
      if !translations.blank? && translations.size > 1
        translations.each do |locale, value|
          execute_with_locale(locale) { super_set_slug(normalized_slug) }
        end
      else
        execute_with_locale(::I18n.locale) { super_set_slug(normalized_slug) }
      end
    end

    def super_set_slug(normalized_slug = nil)
      if should_generate_new_friendly_id?
        candidates = FriendlyId::Candidates.new(self, normalized_slug || send(friendly_id_config.base))
        slug = slug_generator.generate(candidates) || resolve_friendly_id_conflict(candidates)
        self.send("#{friendly_id_config.slug_column}=", slug)
      end
    end

    def get_field_translations_hash
      self.send("#{friendly_id_config.slug_column}_translations")
    end

    # Auxiliar function to execute a block with other locale set
    #
    def execute_with_locale(locale=::I18n.locale, &block)
      actual_locale = ::I18n.locale
      ::I18n.locale = locale

      block.call

      ::I18n.locale = actual_locale
    end

    # Override the existing check in FinderMethod module.
    # This probably could be solved in other way les intrusive with friendly_id
    # classes.
    FriendlyId::FinderMethods.class_eval do
      def exists_by_friendly_id?(id)
        send("with_#{friendly_id_config.query_field}_translation", id).exists?
      end
    end
  end
end
