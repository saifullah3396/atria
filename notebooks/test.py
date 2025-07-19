# # now lets upload the dataset to the atria hub
# from atria_datasets.core.dataset.atria_dataset import AtriaHubDataset

# dataset = AtriaHubDataset.load_from_hub(
#     name="mytestuser1/test-cifar10-4", streaming=False
# )
# print(dataset)
# # for sample in len(dataset.train):
# #     print(sample)
# #     break  # just print the first sample

# now we first load the cifar10 dataset from the atria datasets predefiend registry
from atria_datasets import AtriaImageDataset
from atria_datasets.core.dataset.atria_delta_dataset import AtriaDeltaDataset

dataset = AtriaImageDataset.load_from_registry("cifar10")
delta_dataset = AtriaDeltaDataset.from_atria_dataset(
    dataset=dataset,
)
print("delta_dataset", delta_dataset, delta_dataset.config)
delta_dataset.upload_to_hub("test-cifar10-4-delta")

# hub_dataset = AtriaImageDataset.load_from_hub(
#     name="mytestuser1/test-cifar10-4", streaming=True
# )
# print(dataset.config)
# print(hub_dataset.config)
# print(dataset._storage_dir, hub_dataset._storage_dir)
# print(hub_dataset)
# # now lets upload the dataset to the atria hub
# dataset.upload_to_hub("test-cifar10-4")
