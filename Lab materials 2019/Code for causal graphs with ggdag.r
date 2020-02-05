# ************************************************
### simon munzert
### causal graphs
# ************************************************

source("packages.r")



## Drawing DAGs with ggdag -----------------------

# see
browseURL("https://ggdag.netlify.com/articles/intro-to-ggdag.html")
browseURL("https://ggdag.netlify.com/articles/intro-to-dags.html")
browseURL("https://ggdag.netlify.com/articles/bias-structures.html")

#  set theme of all DAGs to `theme_dag()`
theme_set(theme_dag())

# directed edge
dagify(y ~ x) %>% 
  ggdag()

# bi-directed edge
dagify(y ~~ x) %>% 
  ggdag()


# canonicalize the DAG: add the latent variable in to the graph
dagify(y ~~ x) %>% 
  ggdag_canonical() 

# a cyclic graph
dagify(y ~ x,
       x ~ a,
       a ~ y) %>% 
  ggdag() 

# structural causal graphs

# When we're assessing the causal effect between an exposure and an outcome, drawing our assumptions in the form of a DAG can help us pick the right model without having to know much about the math behind it. Another way to think about DAGs is as non-parametric structural equation models (SEM): we are explicitly laying out paths between variables, but in the case of a DAG, it doesn't matter what form the relationship between two variables takes, only its direction. The rules underpinning DAGs are consistent whether the relationship is a simple, linear one, or a more complicated function.

# Let's say we're looking at the relationship between smoking and cardiac arrest. We might assume that smoking causes changes in cholesterol, which causes cardiac arrest:

smoking_ca_dag <- dagify(cardiacarrest ~ cholesterol,
                         cholesterol ~ smoking + weight,
                         smoking ~ unhealthy,
                         weight ~ unhealthy,
                         labels = c("cardiacarrest" = "Cardiac\n Arrest", 
                                    "smoking" = "Smoking",
                                    "cholesterol" = "Cholesterol",
                                    "unhealthy" = "Unhealthy\n Lifestyle",
                                    "weight" = "Weight"),
                         latent = "unhealthy",
                         exposure = "smoking",
                         outcome = "cardiacarrest")

ggdag(smoking_ca_dag, text = FALSE, use_labels = "label")

# finding pathways between variables
ggdag_paths(smoking_ca_dag, text = FALSE, use_labels = "label")

# identify covariate adjustment sets
ggdag_adjustment_set(smoking_ca_dag, text = FALSE, use_labels = "label")

# colliders
fever_dag <- collider_triangle(x = "Influenza", 
                               y = "Chicken Pox", 
                               m = "Fever") 

ggdag(fever_dag, text = FALSE, use_labels = "label")

# no d-separation necessary
ggdag_dseparated(fever_dag, text = FALSE, use_labels = "label")

# what happens if we nevertheless control for m?
ggdag_dseparated(fever_dag, controlling_for = "m", 
                 text = FALSE, use_labels = "label")

# and what happens if we control for descendants of a collider?
dagify(fever ~ flu + pox, 
       acetaminophen ~ fever,
       labels = c("flu" = "Influenza",
                  "pox" = "Chicken Pox",
                  "fever" = "Fever",
                  "acetaminophen" = "Acetaminophen")) %>% 
  ggdag_dseparated(from = "flu", to = "pox", controlling_for = "acetaminophen",
                   text = FALSE, use_labels = "label")



## Drawing DAGs with dagitty -----------------------

browseURL("https://cran.r-project.org/web/packages/dagitty/vignettes/dagitty4semusers.html")

g1 <- dagitty( "dag {
    A -> B -> C
}")

g2 <- dagitty( "dag {
    Y <- X <- Z1 <- V -> Z2 -> Y
    Z1 <- W1 <-> W2 -> Z2
    X <- W1 -> Y
    X <- W2 -> Y
}")

plot(graphLayout(g1))
