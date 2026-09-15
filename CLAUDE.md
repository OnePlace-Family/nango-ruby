# nango-ruby

Ruby client gem for the Nango API, used by the `continuum` Rails app for OAuth connections and proxied CRM calls. The layout is a fork of the `ruby-openai` gem, which is why some README wording still says "OpenAI".

## Commands

```bash
bundle install
bundle exec rake          # default: rspec, then rubocop
bundle exec rspec         # tests (spec/, webmock + vcr)
bundle exec rubocop -a    # lint/autofix; RuboCop is pinned to 1.50, TargetRubyVersion 2.6, LineLength 100, double quotes
```

There is no CI and no git hook. The Claude PostToolUse hook runs `rubocop -a` on the edited file and exits 2 on remaining offences.

## Conventions

- One file per API area under `lib/nango/` (`connections`, `integrations`, `proxy`, `records`, `providers`, `actions`); HTTP goes through `lib/nango/http.rb` and `http_headers.rb` only.
- Keep `required_ruby_version >= 2.6` unless the consuming app has moved; do not add dependencies beyond Faraday without a reason in the PR body.
- Bump `lib/nango/version.rb` and `Gemfile.lock` together; the Rails app pins this gem by git ref.
- Tests use webmock stubs, not live Nango. No tests that assert on log output.

## Pull requests

Body sections in this order: **Why**, **What changed**, **Testing**, **Notes**. Reference the Linear issue by id.
