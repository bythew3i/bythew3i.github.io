# bythew3i Blog
- Welcome!
- Derived from [Hux Blog](https://huangxuan.me/)

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [bythew3i Blog](#bythew3i-blog)
  - [Post Creation](#post-creation)
  - [Template Posts](#template-posts)
    - [Post (Image)](#post-image)
    - [Post (Text)](#post-text)
    - [Keynote](#keynote)
    - [Page](#page)
    - [Default](#default)
  - [Theme Modification](#theme-modification)

<!-- /code_chunk_output -->


## Post Creation





## Template Posts
### Post (Image)
```
---
layout:         post
title:          XXX
subtitle:       XXX
date:           YYYY-MM-DD | YYYY-MM-DD HH:MM:SS
author:         XXX
img-path:       XXX
header-img:     Image Path
header-mask:    0.3
catalog:        true
tags:
    - A
    - B
---
```

### Post (Text)
```
---
layout:         post
title:          XXX
subtitle:       XXX
date:           YYYY-MM-DD | YYYY-MM-DD HH:MM:SS
author:         XXX
header-style:   text 
catalog:        true
tags:
    - A
    - B
---
```


### Keynote
```
---
layout:         keynote
title:          XXX
subtitle:       XXX
iframe:         Slides Path
navcolor:       invert
date:           YYYY-MM-DD | YYYY-MM-DD HH:MM:SS
author:         XXX
tags:
    - A
    - B
---
```


### Page
```
---
layout:         page
title:          XXX
description:    XXX
header-img:     XXX
header-mask:    0.3
---
```


### Default
```
---
layout:         default
title:          XXX
description:    XXX
header-img:     XXX
header-mask:    0.3
hide-in-nav:    true
---
```


## Theme Modification

1. Modify the less files in `less/`
2. Run [grunt](https://gruntjs.com/getting-started):

If you have not install grunt,
```bash
npm install -g grunt-cli
```
cd to the project root path
```bash
npm install
grunt
```
