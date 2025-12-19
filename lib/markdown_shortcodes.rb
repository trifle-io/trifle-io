# frozen_string_literal: true

# Adds lightweight Markdown shortcodes to avoid writing raw HTML in docs.
# Supported blocks:
# - Callout:    :::callout note "Title"\nmarkdown...\n:::
# - Signature:  :::signature signature text\nname | type | required|optional | description\n:::
# - Tabs:       :::tabs\n@tab Title\nmarkdown\n@tab Other\nmarkdown\n:::
#
# These are expanded before Redcarpet renders the Markdown, so inner content
# still benefits from Markdown parsing (lists, code fences, etc.).

require 'securerandom'

module Trifle
  module Docs
    module Harvester
      module Markdown
        module Shortcodes
          def preprocess_markdown(body)
            processed = body.dup
            processed = process_tabs(processed)
            processed = process_signature(processed)
            processed = process_callouts(processed)
            processed
          end

          private

          def process_callouts(text)
            text.gsub(/:::callout\s+(\w+)(?:\s+"([^"]+)")?\s*\n(.*?)\n:::/m) do
              kind = Regexp.last_match(1)
              title = Regexp.last_match(2) || kind.capitalize
              inner_md = Regexp.last_match(3).strip
              inner_html = render_fragment(inner_md)

              %(<div class="callout callout-#{kind}"><p class="callout-title">#{title}</p>#{inner_html}</div>)
            end
          end

          def process_signature(text)
            text.gsub(/:::signature\s+(.+?)\s*\n(.*?)\n:::/m) do
              signature = Regexp.last_match(1).strip
              args_block = Regexp.last_match(2)

              args = args_block.lines.map(&:strip).reject(&:empty?).map do |line|
                if line =~ /^([^|]+)\|\s*(.+)\s*\|\s*(required|optional)\s*\|\s*(.+)$/
                  {
                    name: Regexp.last_match(1).strip,
                    type: Regexp.last_match(2).strip,
                    required: Regexp.last_match(3).downcase.start_with?('req'),
                    desc: Regexp.last_match(4).strip
                  }
                end
              end.compact

              arg_rows = args.map do |arg|
                required_badge = arg[:required] ? '<span class="badge badge-required">Required</span>' : '<span class="badge badge-optional">Optional</span>'
                desc_html = render_fragment(arg[:desc])
                %(<div class="arg-row"><dt><code>#{arg[:name]}</code> <span class="badge badge-type">#{arg[:type]}</span> #{required_badge}</dt><dd>#{desc_html}</dd></div>)
              end.join

              %(<div class="method-card"><div class="method-card-title">Signature</div><div class="method-card-signature">`#{signature}`</div><dl class="arg-list">#{arg_rows}</dl></div>)
            end
          end

          def process_tabs(text)
            text.gsub(/:::tabs\s*\n(.*?)\n:::/m) do
              tabs_block = Regexp.last_match(1)
              tabs = []
              current = nil
              tabs_block.lines.each do |line|
                if line =~ /^@tab\s+(.+)$/
                  tabs << { title: Regexp.last_match(1).strip, body: String.new }
                  current = tabs.last
                  next
                end
                current[:body] << line if current
              end

              next Regexp.last_match(0) if tabs.empty?

              group = SecureRandom.hex(4)
              initial = "#{group}-tab-0"

              options = tabs.each_with_index.map do |tab, idx|
                key = "#{group}-tab-#{idx}"
                %(<option value="#{key}" #{idx.zero? ? 'selected' : ''}>#{tab[:title]}</option>)
              end.join

              buttons = tabs.each_with_index.map do |tab, idx|
                key = "#{group}-tab-#{idx}"
                %(<button type="button" class="tab-link" :class="{ 'tab-link-active': tab === '#{key}' }" @click="tab = '#{key}'">#{tab[:title]}</button>)
              end.join

              panels = tabs.each_with_index.map do |tab, idx|
                key = "#{group}-tab-#{idx}"
                body = render_fragment(tab[:body].strip)
                %(<div class="tab-panel" x-show="tab === '#{key}'" x-cloak>#{body}</div>)
              end.join

              %(<div class="tab-group" x-data="{ tab: '#{initial}' }" x-cloak><div class="tab-select"><select aria-label="Select a tab" x-model="tab">#{options}</select><svg viewBox="0 0 16 16" fill="currentColor" aria-hidden="true" class="pointer-events-none"><path d="M4.22 6.22a.75.75 0 0 1 1.06 0L8 8.94l2.72-2.72a.75.75 0 1 1 1.06 1.06l-3.25 3.25a.75.75 0 0 1-1.06 0L4.22 7.28a.75.75 0 0 1 0-1.06Z" clip-rule="evenodd" fill-rule="evenodd" /></svg></div><div class="tab-nav"><nav class="tab-nav-links" aria-label="Tabs">#{buttons}</nav></div>#{panels}</div>)
            end
          end

          def render_fragment(markdown)
            html = markdown_renderer.render(markdown).strip
            if html.start_with?('<p>') && html.end_with?('</p>')
              html = html.sub(/\A<p>/, '').sub(%r{</p>\z}, '')
            end
            html
          end
        end

        # Prepend the shortcode processing into the Markdown conveyor.
        class Conveyor
          prepend Shortcodes

          def markdown_renderer
            @markdown_renderer ||= Redcarpet::Markdown.new(
              Render.new(with_toc_data: true),
              fenced_code_blocks: true,
              disable_indented_code_blocks: true,
              footnotes: true,
              tables: true
            )
          end

          def toc_renderer
            @toc_renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC)
          end

          def content
            @content = nil unless cache

            @content ||= markdown_renderer.render(
              preprocess_markdown(data.sub(/^---(.*?)---(\s*)/m, ''))
            )
          rescue StandardError => e
            puts "Markdown: Failed to parse CONTENT for #{file}: #{e}"
          end

          def toc
            @toc = nil unless cache

            @toc ||= toc_renderer.render(
              preprocess_markdown(data.sub(/^---(.*?)---(\s*)/m, ''))
            )
          rescue StandardError => e
            puts "Markdown: Failed to parse TOC for #{file}: #{e}"
          end
        end
      end
    end
  end
end
