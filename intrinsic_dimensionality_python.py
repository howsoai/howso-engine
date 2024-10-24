import pmlb
import pprint
from howso.engine import Trainee
from howso.utilities import infer_feature_attributes

df = pmlb.fetch_data("adult")

features = infer_feature_attributes(df)

num_features = len(features.get_names(types="continuous"))
nom_features = features.get_names(types="nominal")

for feature in nom_features:
    num_features += df[feature].nunique() + 1

t = Trainee(features=features)
t.train(df)
t.analyze(p_values=[2])
print(num_features)
print(len(features))
pprint.pprint(
    t.client.execute(
        t.id,
        "estimate_intrinsic_dimensionality",
        {
            "num_samples": 50,
            # "features": list(df.columns),
            # "weight_feature": None,
        }
    )
)
