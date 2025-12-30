# Trifle.io

Public website for [trifle.io](https://trifle.io) build on top of Trifle::Docs.

## Deploy

```sh
helm upgrade --install docs-trifle-io .devops/helm/trifle-io -n docs --set image.tag=<TAG>
```