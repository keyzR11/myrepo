library(tidyverse)
library(aRtsy)
library(ambient)

set.seed(3)
cob1 <- canvas_cobweb(colors = colorPalette("neon2"),background = "black",lines = 500,iterations = 100)
?canvas_cobweb
saveCanvas(cob1, filename = "cob1.png")

set.seed(333)
coltz1 <- canvas_collatz(colors = colorPalette("tuscany3"))
saveCanvas(coltz1, filename = "coltz1.png")


set.seed(13)
cf1 <- canvas_flow(colors = colorPalette("dark2"))
saveCanvas(cf1, filename = "cf1.png")



library(tibble)

set.seed(13)
n <- 250
dt <- tibble(
  x0 = runif(n),
  y0 = runif(n),
  x1 = x0 + runif(n, min = -.2, max = .2),
  y1 = y0 + runif(n, min = -.2, max = .2),
  shade = runif(n), 
  size = runif(n)
)
dt

dt %>%
  ggplot(aes(
    x = x0,
    y = y0,
    xend = x1,
    yend = y1,
    colour = shade,
    size = size
  )) +
  geom_segment(show.legend = FALSE) +
  coord_polar() +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_continuous(expand = c(0, 0)) + 
  scale_color_viridis_c() + 
  scale_size(range = c(0, 10)) + 
  theme_void()

library(purrr)
?accumulate

points_time0 <- expand_grid(x = 1:50, y = 1:30) %>% 
  mutate(time = 0, id = row_number())
ggplot_themed <- function(data) {
  data %>% 
    ggplot(aes(x, y)) +
    coord_equal() + 
    scale_size_identity() + 
    scale_colour_identity() + 
    scale_fill_identity() + 
    theme_void() 
}

points_time0 %>% ggplot_themed()+
  geom_point(size = .5)

field <- function(points, frequency = .1, octaves = 1) {
  ambient::curl_noise(
    generator = ambient::fracture,
    fractal = ambient::billow,
    noise = ambient::gen_simplex,
    x = points$x,
    y = points$y,
    frequency = frequency,
    octaves = octaves,
    seed = 1
  )
}

shift <- function(points, amount, ...) {
  vectors <- field(points, ...)
  points <- points %>%
    mutate(
      x = x + vectors$x * amount,
      y = y + vectors$y * amount,
      time = time + 1,
      id = id
    )
  return(points)
}

points_time1 <- shift(points_time0, amount = 1)
points_time2 <- shift(points_time1, amount = 1)
points_time3 <- shift(points_time2, amount = 1)

pts <- bind_rows(
  points_time0, 
  points_time1, 
  points_time2,
  points_time3
)
map_size <- function(x) {
  ambient::normalise(x, to = c(0, 2))
}
map_alpha <- function(x) {
  ambient::normalise(-x, to = c(0, .5))
}
pts %>% 
  ggplot_themed() +  
  geom_point(
    mapping = aes(
      size = map_size(time), 
      alpha = map_alpha(time)
    ),
    show.legend = FALSE
  )






iterate <- function(pts, time, step, ...) {
  bind_rows(accumulate(
    .x = rep(step, time), 
    .f = shift, 
    .init = pts,
    ...
  ))
}
pts <- points_time0 %>% 
  iterate(time = 3, step = 1)
