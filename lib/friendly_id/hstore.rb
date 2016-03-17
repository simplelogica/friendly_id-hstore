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
        unless model.respond_to?('translated_attribute_names') ||
               model.translated_attribute_names.exclude?(field.to_sym)
          raise "[FriendlyId] You need to translate the '#{field}' field with " \
            "hstore_stranslates (add 'translates :#{field}' in your model '#{model.name}')"
        end
      end
      private :advise_against_untranslated_model
    end

    def set_friendly_id(text, locale = nil)
      ::Globalize.with_locale(locale || ::Globalize.locale) do
        set_slug normalize_friendly_id(text)
      end
    end

    def should_generate_new_friendly_id?
      translation_for(::Globalize.locale).send(friendly_id_config.slug_column).nil?
    end

    def set_slug(normalized_slug = nil)
      if self.translations.size > 1
        self.translations.map(&:locale).each do |locale|
          ::Globalize.with_locale(locale) { super_set_slug(normalized_slug) }
        end
      else
        ::Globalize.with_locale(::Globalize.locale) { super_set_slug(normalized_slug) }
      end
    end

    def super_set_slug(normalized_slug = nil)
      if should_generate_new_friendly_id?
        candidates = FriendlyId::Candidates.new(self, normalized_slug || send(friendly_id_config.base))
        slug = slug_generator.generate(candidates) || resolve_friendly_id_conflict(candidates)
        translation.slug = slug
      end
    end
  end
end
